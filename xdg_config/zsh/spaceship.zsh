SPACESHIP_PROMPT_ASYNC=false

SPACESHIP_PROMPT_ORDER=(
  dir            # Current directory section
  user           # Username section
  host           # Hostname section
  time           # Time stamps section
  git            # Git section (git_branch + git_status)
  # hg             # Mercurial section (hg_branch  + hg_status)
  # package        # Package version
  # node           # Node.js section
  # bun            # Bun section
  # deno           # Deno section
  # ruby           # Ruby section
  # python         # Python section
  pyenv2         # pyenv section
  venv           # virtualenv section
  # elm            # Elm section
  # elixir         # Elixir section
  # xcode          # Xcode section
  # swift          # Swift section
  golang         # Go section
  # perl           # Perl section
  # php            # PHP section
  rust           # Rust section
  haskell        # Haskell Stack section
  # scala          # Scala section
  # kotlin         # Kotlin section
  # java           # Java section
  # lua            # Lua section
  # dart           # Dart section
  # julia          # Julia section
  # crystal        # Crystal section
  # docker         # Docker section
  # docker_compose # Docker section
  # aws            # Amazon Web Services section
  # gcloud         # Google Cloud Platform section
  # azure          # Azure section
  # conda          # conda virtualenv section
  # dotnet         # .NET section
  # ocaml          # OCaml section
  # vlang          # V section
  # zig            # Zig section
  purescript     # PureScript section
  # direnv         # Direnv section
  # erlang         # Erlang section
  # kubectl        # Kubectl context section
  # ansible        # Ansible section
  # terraform      # Terraform workspace section
  # pulumi         # Pulumi stack section
  # ibmcloud       # IBM Cloud section
  # nix_shell      # Nix shell
  # gnu_screen     # GNU Screen section
  # exec_time      # Execution time
  # async          # Async jobs indicator
  line_sep       # Line break
  # battery        # Battery level and status
  jobs           # Background jobs indicator
  exit_code      # Exit code section
  sudo           # Sudo indicator
  char           # Prompt character
)

SPACESHIP_PROMPT_ADD_NEWLINE=false

# Dir
SPACESHIP_DIR_TRUNC=0
SPACESHIP_DIR_TRUNC_REPO=false
SPACESHIP_DIR_PREFIX=""
SPACESHIP_DIR_SUFFIX=" "
SPACESHIP_DIR_COLOR="#dcc342"

# User
SPACESHIP_USER_SHOW=0
# SPACESHIP_USER_PREFIX="["
# SPACESHIP_USER_SUFFIX=""
# SPACESHIP_USER_COLOR="gray"

# Host
# SPACESHIP_HOST_SHOW=always
# SPACESHIP_HOST_PREFIX="@"
SPACESHIP_HOST_PREFIX=""
# SPACESHIP_HOST_SUFFIX=" "
SPACESHIP_HOST_COLOR="gray"
SPACESHIP_HOST_COLOR_SSH="gray"

# Display time
SPACESHIP_TIME_SHOW=true
SPACESHIP_TIME_FORMAT='%D{%H:%M}'
SPACESHIP_TIME_PREFIX="["
SPACESHIP_TIME_SUFFIX="] "
SPACESHIP_TIME_COLOR=gray

# Git
SPACESHIP_GIT_BRANCH_PREFIX=""
SPACESHIP_GIT_BRANCH_COLOR="67"

SPACESHIP_GIT_STATUS_PREFIX=""
SPACESHIP_GIT_STATUS_SUFFIX=""
SPACESHIP_GIT_STATUS_MODIFIED="±"
SPACESHIP_GIT_STATUS_COLOR="166"

# Pyenv
SPACESHIP_PYENV2_PREFIX=""
SPACESHIP_PYENV2_SYMBOL="λ "
SPACESHIP_PYENV2_COLOR="#ca8288"

# venv
SPACESHIP_VENV_PREFIX=""
SPACESHIP_VENV_SYMBOL="λ "
SPACESHIP_VENV_COLOR="#ca8288"

# Char
SPACESHIP_CHAR_SYMBOL="\$ "
SPACESHIP_CHAR_COLOR_SUCCESS="gray"

# Rust
SPACESHIP_RUST_PREFIX=""
SPACESHIP_RUST_SYMBOL=" "

# Exit code
# SPACESHIP_EXIT_CODE_SHOW=true
