#!/bin/bash

# Generate the flamegraph.
# Special thanks to Brendan Gregg.
# https://github.com/brendangregg/FlameGraph.git

# Get on the input arguments.
if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <PROFILE DATA> <SVG OUTPUT>" 1>&2
  exit 1
fi
profile_data=$1
svg_graph=$2

# Get the flame graph repository.
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
