ARG BASE_IMAGE

FROM alpine/git AS base
ENTRYPOINT ["sh"]

FROM ${BASE_IMAGE:-base}
RUN \
  wget -O- \
  "https://gitlab.com/api/v4/users/rafaelgieschke/projects?include_subgroups=true&per_page=100" \
  "https://api.github.com/users/rafaelgieschke/repos?per_page=100" \
  "https://api.github.com/users/rafaelgieschke/repos?per_page=100&page=2" \
  "https://api.github.com/users/eaasi/repos?per_page=100" \
  "https://api.github.com/users/emulation-as-a-service/repos?per_page=100" \
  "https://api.github.com/users/opensourcevdi/repos?per_page=100" \
  | grep -Eo '"https://[^"]+\.git"' | cut -d '"' -f 2 \
  | sed 'h;s/\.git$/.wiki.git/;H;g' \
  | xargs -n 1 sh -c 'dir="$(printf %s "$0" | tr / "\\\\")"; git clone --bare --mirror "$0" "$dir"; cd -- "$dir" && git fetch' \
  || true; du -s *
