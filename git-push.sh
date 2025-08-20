#!/bin/bash

check_fzf() {
    if ! command -v fzf &> /dev/null; then
        echo "Error: fzf is not installed" >&2
        exit 1
    fi
}

get_base_branches() {
    # Get remote branches (excluding HEAD and current branch)
    current_branch=$(git branch --show-current)
    git branch -r --format="%(refname:short)" | \
        grep -v 'HEAD' | \
        sed 's/origin\///' | \
        grep -v "^$current_branch$" | \
        sort -u
}

select_base_branch_fzf() {
    echo "🌿 Select base branch for the PR:"
    
    selected=$(get_base_branches | fzf \
        --height=40% \
        --layout=reverse \
        --border \
        --prompt="Select base branch: " \
        --preview="git log --oneline -10 --color=always {}" \
        --preview-window=right:50% \
        --header="Use arrow keys to navigate, Enter to select, Esc to cancel")
    
    if [ -z "$selected" ]; then
        echo "⏭️  No branch selected, using 'main' as default"
        echo "main"
    else
        echo "$selected"
    fi
}



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
        else
            echo "❓ Create a Pull Request for branch '$current_branch'? (y/n):"
            read -r create_pr
            case "$create_pr" in
            [yY] | [yY][eE][sS])
                # Select base branch using fzf
                check_fzf
                base_branch=$(select_base_branch_fzf)
                
                echo "📋 Creating PR with base branch: $base_branch"
                gh pr create --title "$(git br --show-current)" --base "$base_branch" --fill --assignee @me
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
