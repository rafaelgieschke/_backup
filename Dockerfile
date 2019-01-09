ARG CI_APPLICATION_REPOSITORY
ARG CI_COMMIT_REF_SLUG

FROM ${CI_APPLICATION_REPOSITORY}:${CI_COMMIT_REF_SLUG}

RUN \
  mkdir -p gitlab; cd gitlab; \
  wget -O- "https://gitlab.com/api/v4/users/rafaelgieschke/projects?include_subgroups=true" \
  | grep -Eo '"http_url_to_repo"\s*:\s*"[^"]+"' | cut -d '"' -f 4 \
  | sed 'h;s/\.git$/.wiki.git/;H;g' \
  | grep rafaelgieschke \
  | xargs -n 1 sh -c 'git clone --bare --mirror "$0"; cd -- "$(basename -- "$0")" && git fetch' \
  || true
RUN \
  mkdir -p github; cd github; \
  wget -O- "https://api.github.com/users/rafaelgieschke/repos" \
  | grep -Eo '"clone_url"\s*:\s*"[^"]+"' | cut -d '"' -f 4 \
  | sed 'h;s/\.git$/.wiki.git/;H;g' \
  | xargs -n 1 sh -c 'git clone --bare --mirror "$0"; cd -- "$(basename -- "$0")" && git fetch' \
  || true
