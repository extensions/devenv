export PATH="$PATH:$HOME/.deno/bin"

function x {
  declare argc="$#"
  declare owd="$PWD"
  declare target_repo="${1:-}"
  declare target_branch="${2:-}"
  cd /extensions
  for repo in $(gh repo list extensions --limit 64 --no-archived --json=name --template="{{range .}}{{.name}} {{end}}"); do
    echo "$(tput smul)updating /extensions/${repo}$(tput sgr0)"
    if ! test -d "/extensions/${repo}"; then
      cd /extensions
      git clone --verbose --no-single-branch --shallow-since="1 month" https://github.com/extensions/${repo}
    fi
    cd "/extensions/${repo}"
    git remote set-branches origin "*"
    git fetch --no-tags --verbose
    echo
  done

  if [ "$argc" -ge 1 ]; then
    echo "$(tput smul)opening /extensions/${target_repo}$(tput sgr0)"
    cd /extensions/"${target_repo}"
    if [ "$argc" -ge 2 ]; then
      git switch "${target_branch}"
    fi
    git pull --verbose --ff-only || echo "Can't fast-forward."
    echo
  else
    cd "$owd"
  fi
}
