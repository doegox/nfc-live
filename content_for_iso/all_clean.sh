#!/bin/bash

rm -rf @config
for i in */clean.sh; do cd $(dirname $i); ./$(basename $i); cd -; done
