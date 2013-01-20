#!/bin/bash

for i in */prepare.sh; do cd $(dirname $i); ./$(basename $i); cd -; done
