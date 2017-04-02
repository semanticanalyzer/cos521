#!/bin/bash

LANG=en
pushd data

#ruby ../crawl.rb $1
python ../tweet_archive_parser.py ${LANG}_${1}.json
python ../tweet_trender.py ${LANG}_${1}.out

popd
