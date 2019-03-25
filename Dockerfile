FROM fluent/fluentd:v1.3.3-debian-onbuild-1.0

# Use root account to use apt
USER root

# below RUN includes plugin as examples elasticsearch is not required
# you may customize including plugins as you wish
RUN buildDeps="sudo make gcc g++ libc-dev ruby-dev" \
  && apt-get update \
  && apt-get install -y --no-install-recommends $buildDeps \
  && apt-get install -y --no-install-recommends git \
  && sudo gem install specific_install \
  && sudo gem install fluent-plugin-docker_metadata_filter \
  && sudo gem install fluent-plugin-kubernetes_metadata_filter \
  && sudo gem install fluent-plugin-elasticsearch \
  && sudo gem install fluent-plugin-s3 -v 1.0.0 --no-document \
  && sudo gem install fluent-plugin-rewrite-tag-filter \
  && sudo gem specific_install -l https://github.com/arcivanov/fluent-plugin-json-in-json.git \
  && sudo gem sources --clear-all \
  && SUDO_FORCE_REMOVE=yes apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $buildDeps \
  && rm -rf /var/lib/apt/lists/* /home/fluent/.gem/ruby/2.3.0/cache/*.gem

COPY set_umask.sh /bin/set_umask.sh

USER fluent
ENTRYPOINT ["tini",  "--", "/bin/set_umask.sh"]
CMD ["fluentd"]
