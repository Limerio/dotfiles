#!/bin/bash

set -e 

check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "Error: Not in a git repository" >&2
        exit 1
    fi
}

check_fzf() {
    if ! command -v fzf &> /dev/null; then
        echo "Error: fzf is not installed. Please install it first." >&2
        echo "Install with: brew install fzf (on macOS)" >&2
        exit 1
    fi
}

get_branches() {
    git branch --format="%(refname:short)" | sed 's/^/local: /'
    
    git branch -r --format="%(refname:short)" | \
        grep -v 'HEAD' | \
        while read -r branch; do
            local_branch="${branch#origin/}"
            if ! git show-ref --verify --quiet "refs/heads/$local_branch" 2>/dev/null; then
                echo "remote: $branch"
            fi
        done
}

checkout_with_fzf() {
    echo "Select a branch to checkout:"
    
    selected=$(get_branches | fzf \
        --height=40% \
        --layout=reverse \
        --border \
        --prompt="Select branch: " \
        --preview="echo {} | sed 's/^[^:]*: //' | xargs git log --oneline -10 --color=always" \
        --preview-window=right:50% \
        --header="Use arrow keys to navigate, Enter to select, Esc to cancel")
    
    if [ -z "$selected" ]; then
        echo "No branch selected. Exiting."
        exit 0
    fi
    
    branch_name=$(echo "$selected" | sed 's/^[^:]*: //')
    
    echo "Selected: $branch_name"
    
    if echo "$selected" | grep -q "^remote:"; then
        local_branch_name="${branch_name#origin/}"
        git checkout -b "$local_branch_name" "$branch_name"
    else
        git checkout "$branch_name"
    fi
}

checkout_direct() {
    local branch_name="$1"
    echo "Checking out branch: $branch_name"
    
    if git checkout "$branch_name" 2>/dev/null; then
        echo "Successfully checked out '$branch_name'"
    else
        if ! git checkout -b "$branch_name" "origin/$branch_name" 2>/dev/null; then
            echo "Error: Could not checkout or create branch '$branch_name'" >&2
            echo "Available branches:" >&2
            git branch -a >&2
            exit 1
        fi
    fi
}

main() {
    check_git_repo
    
    if [ $# -eq 1 ]; then
        checkout_direct "$1"
    elif [ $# -eq 0 ]; then
        check_fzf
        checkout_with_fzf
    else
        echo "Usage: $0 [branch-name]" >&2
        echo "  branch-name: Optional. Branch to checkout directly" >&2
        echo "  If no branch-name provided, fzf will be used for interactive selection" >&2
        exit 1
    fi
}

main "$@"
