#!/bin/bash

sort -n $1 | uniq -c > $2
