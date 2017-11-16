#!/bin/bash

# Generate the flamegraph.
# Special thanks to Brendan Gregg.
# Here is his GitHub repository: https://github.com/brendangregg/FlameGraph.git
# @author Kevin Cheng
# @since  11/15/2017

# Check on the input arguments.
if [[ $# -ne 2 ]]; then
  echo "Usage: ./$0 <PROFILE DATA> <SVG OUTPUT>" 1>&2
  exit 1
fi

# Process the command line argument.
profile_data=$1
svg_graph=$2

# Check the necessary scipts. This part of code may need to change if
# there is any changes on the GitHub repository.
if [[ ! -d 'FlameGraph' ]]; then
  git clone https://github.com/brendangregg/FlameGraph.git
  rm -rf ./FlameGraph/.git
fi

# Make the convenient soft links.
if [[ ! (-f 'stackcollapse-perf.pl' || -f 'flamegraph.pl') ]]; then
  ln -s "./FlameGraph/stackcollapse-perf.pl" .
  ln -s "./FlameGraph/flamegraph.pl" .
fi

# Plot the flame graph.
perf script -i ${profile_data} | ./stackcollapse-perf.pl | ./flamegraph.pl > ${svg_graph}
