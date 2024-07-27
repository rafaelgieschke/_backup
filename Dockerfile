ARG CI_APPLICATION_REPOSITORY
ARG CI_COMMIT_REF_SLUG

FROM ${CI_APPLICATION_REPOSITORY}:${CI_COMMIT_REF_SLUG}
ENTRYPOINT ["sh"]

RUN \
  wget -O- \
  "https://gitlab.com/api/v4/users/rafaelgieschke/projects?include_subgroups=true&per_page=100" \
  "https://api.github.com/users/rafaelgieschke/repos?per_page=100" \
  "https://api.github.com/users/rafaelgieschke/repos?per_page=100&page=2" \
  | grep -Eo '"https://[^"]+\.git"' | cut -d '"' -f 2 \
  | sed 'h;s/\.git$/.wiki.git/;H;g' \
  | xargs -n 1 sh -c 'dir="$(printf %s "$0" | tr / _)"; git clone --bare --mirror "$0" "$dir"; cd -- "$dir" && git fetch' \
  || true; du -s *
