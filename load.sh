#!/bin/sh

rake db:drop db:create db:migrate db:seed

for file in ../transition-stats/totals/*.tsv
do
    echo "\n::: $file :::"
    bundle exec rake import_totals[$file]
done

exit

for file in ../transition-stats/hits/*.tsv
do
    echo "\n::: $file :::"
    bundle exec rake import_hits[$file]
done

