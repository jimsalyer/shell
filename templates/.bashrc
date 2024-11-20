. "$HOME/shell/env.sh"
. "$HOME/shell/functions.sh"
. "$HOME/shell/aliases.sh"

ensure_interactive
load_dircolors "$HOME/dracula/dircolors/.dircolors"
load_posh bash "$HOME/shell/config/omp.json"