echo "🚀 Starting enhanced git push..."

if git push "$@"; then
    echo "✅ Push successful!"

    current_branch=$(git br --show-current)

    if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
        echo "🔄 Checking for PR creation..."

        if gh prv >/dev/null 2>&1; then
            echo "ℹ️  Pull Request already exists for branch '$current_branch'"
            pr_url=$(gh pr view "$current_branch" --json url -q '.url')
            echo "🔗 PR URL: $pr_url"

            echo "🌐 Open PR in browser? (y/n):"
            read -r open_response
            case "$open_response" in
            [yY] | [yY][eE][sS])
                gh pr view "$current_branch" --web
                ;;
            esac
        else
            echo "❓ Create a Pull Request for branch '$current_branch'? (y/n):"
            read -r create_pr
            case "$create_pr" in
            [yY] | [yY][eE][sS])
                gh pr create --title "$(git br --show-current)" --fill --assignee @me

                echo "📝 Put the new PR in draft? (y/n):"
                read -r draft
                case "$draft" in
                [yY] | [yY][eE][sS])
                    gh pr ready --undo
                    ;;
                esac

                echo "🌐 Open the new PR in browser? (y/n):"
                read -r open_response
                case "$open_response" in
                [yY] | [yY][eE][sS])
                    gh prvw
                    ;;
                esac
                ;;
            *)
                echo "⏭️  Skipping PR creation"
                ;;
            esac
        fi
    else
        if ! command -v gh >/dev/null 2>&1; then
            echo "⚠️  GitHub CLI not installed"
            echo "💡 Install it from: https://cli.github.com/"
        else
            echo "⚠️  GitHub CLI not authenticated"
            echo "💡 Run: gh auth login"
        fi
    fi
else
    echo "❌ Push failed!"
    exit 1
fi

echo "🎉 Done!"
