FROM fluent/fluentd:v1.3.3-debian-onbuild-1.0

# Use root account to use apt
USER root

# below RUN includes plugin as examples elasticsearch is not required
# you may customize including plugins as you wish
RUN buildDeps="sudo make gcc g++ libc-dev ruby-dev" \
  && apt-get update \
  && apt-get install -y --no-install-recommends $buildDeps \
  && sudo gem install fluent-plugin-docker_metadata_filter \
  && sudo gem install fluent-plugin-kubernetes_metadata_filter \
  && sudo gem install fluent-plugin-elasticsearch \
  && sudo gem install fluent-plugin-formatter_sprintf \
  && sudo gem sources --clear-all \
  && SUDO_FORCE_REMOVE=yes apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $buildDeps \
  && rm -rf /var/lib/apt/lists/* /home/fluent/.gem/ruby/2.3.0/cache/*.gem

USER fluent
