fo() {
  IFS=$'\n' out=("$(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)")
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-code} "$file"
  fi
}

fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

fif() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}

fifo() {
    find . -type f -not -path "*/*venv/*" -not -name "*.pyc" -print0 | xargs -0 grep -i $1 | fzf
}

hist() {
  local selected_command=$(history | fzf +s +m -n2..,.. --tac | awk '{$1=""; print $0}')
  if [ -n "$selected_command" ]; then
    echo "$selected_command" | xargs -I {} sh -c "{}"
  fi
}