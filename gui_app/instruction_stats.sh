#!/bin/bash

sort -n $1 | uniq -c | sort -k1 -n -r > $2
