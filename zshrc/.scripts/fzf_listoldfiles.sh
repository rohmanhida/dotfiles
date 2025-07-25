#!/bin/sh

# Script to list recent files and open nvim using fzf
# set to an alias le in .zshrc

list_oldfiles() {
    # Get the oldfiles list from Neovim
    local oldfiles=($(nvim -u NONE --headless +'lua io.write(table.concat(vim.v.oldfiles, "\n") .. "\n")' +qa))
    # Filter invalid paths or files not found
    local valid_files=()
    for file in "${oldfiles[@]}"; do
        if [[ -f "$file" ]]; then
            valid_files+=("$file")
        fi
    done
    # Use fzf to select from valid files
    local files=($(printf "%s\n" "${valid_files[@]}" | \
        grep -v '\[.*' | \
        fzf --multi \
        --preview 'bat --theme="rose-pine-dawn" --color=always -n --line-range=:500 {} 2>/dev/null || echo "Error previewing file"' \
        --height=70% \
        --layout=default))

  # Open selected files in Neovim
  [[ ${#files[@]} -gt 0 ]] && nvim "${files[@]}"
}

# Call the function
list_oldfiles "$@"
