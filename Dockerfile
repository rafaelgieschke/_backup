arg CI_APPLICATION_REPOSITORY
arg CI_COMMIT_REF_SLUG

from ${CI_APPLICATION_REPOSITORY}:${CI_COMMIT_REF_SLUG}

run \
  wget -O- "https://gitlab.com/api/v4/users/rafaelgieschke/projects?include_subgroups=true" \
  | grep -E '"http_url_to_repo":"[^"]+"' -o | cut -d '"' -f 4 \
  | sed 'h;s/\.git$/.wiki.git/;H;g' \
  | grep rafaelgieschke \
  | xargs -n 1 sh -c 'git clone --bare --mirror "$1"; cd -- "$(basename -- "$1")" && git fetch' - \
  ; true
run \
  mkdir -p github; cd github; \
  wget -O- "https://api.github.com/users/rafaelgieschke/repos" \
  | grep -E '"clone_url":\s+"[^"]+"' -o | cut -d '"' -f 4 \
  | sed 'h;s/\.git$/.wiki.git/;H;g' \
  | xargs -n 1 sh -c 'git clone --bare --mirror "$1"; cd -- "$(basename -- "$1")" && git fetch' - \
  ; true
