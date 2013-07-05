#!/bin/sh

# depends upon:
# access to the git submodules redirector and transition-stats
# being able to dig for the cname of each host

set -x
git submodule sync
git submodule update --init
bundle exec rake db:drop db:create db:migrate db:seed
bundle exec rake 'import_totals[data/transition-stats/totals/*.tsv]'
bundle exec rake 'import_hits[data/transition-stats/hits/*.tsv]'
bundle exec rake 'import_mappings[data/redirector/data/mappings/*.csv]'
bundle exec rake 'fetch_hosts_dns'
bundle exec rake 'update_organisation_redirect_flag'
