#!/bin/sh

# depends upon:
# git clone --depth 1 git@github.com:alphagov/redirector.git data/redirector
# git clone --depth 1 git@github.com:alphagov/transition-stats data/transition-stats

set -x
bundle exec rake db:drop db:create db:migrate db:seed
bundle exec rake 'import_totals[data/transition-stats/totals/*.tsv]'
bundle exec rake 'import_hits[data/transition-stats/hits/*.tsv]'
