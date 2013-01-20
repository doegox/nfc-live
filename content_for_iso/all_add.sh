#!/bin/bash

for i in */add.sh; do cd $(dirname $i); ./$(basename $i); cd -; done
