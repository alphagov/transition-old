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

# Get the mappings from director, update dependent data
bundle exec rake 'import_mappings:'$STYLE'[data/redirector/data/mappings/*.csv]'
bundle exec rake 'fetch_hosts_dns'
bundle exec rake 'update_organisation_redirect_flag'

# Populate the traffic data. Empty the tables first so that we can use 'fast'
# for speed. In production this should be done out of hours.
bundle exec rake 'import_totals:truncate'
bundle exec rake 'import_totals:fast[data/transition-stats/totals/*.tsv]'
bundle exec rake 'import_hits:truncate'
bundle exec rake 'import_hits:fast[data/transition-stats/hits/*.tsv]'
