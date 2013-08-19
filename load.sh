#!/bin/sh

# depends upon:
# access to the git submodules redirector and transition-stats
# being able to dig for the cname of each host

set -x
git submodule sync
git submodule update --init

if [ "$CLEAN_SLATE" = "1" ]; then
  bundle exec rake db:drop db:create db:migrate
  STYLE='fast'
else
  STYLE='robust'
fi

bundle exec rake db:seed

bundle exec rake 'import_totals:'$STYLE'[data/transition-stats/totals/*.tsv]'
bundle exec rake 'import_hits:'$STYLE'[data/transition-stats/hits/*.tsv]'
bundle exec rake 'import_mappings:'$STYLE'[data/redirector/data/mappings/*.csv]'

bundle exec rake 'fetch_hosts_dns'
bundle exec rake 'update_organisation_redirect_flag'
