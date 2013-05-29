#!/bin/sh

set -x
rm -rf data
mkdir data

git clone --depth 1 git@github.com:alphagov/redirector.git data/redirector
git clone --depth 1 git@github.com:alphagov/transition-stats data/transition-stats

rake db:drop db:create db:migrate db:seed

set +x

for file in data/transition-stats/totals/*.tsv
do
    set -x
    bundle exec rake import_totals[$file]
    set +x
done

for file in data/transition-stats/hits/*.tsv
do
    set -x
    bundle exec rake import_hits[$file]
    set +x
done
