#!/bin/bash

# usage: ./create-test-data.sh project_name nr_entries output_file
#     or ./create-test-data.sh to choose default arguments

set -eu

PROJ_NAME=${1:-"test"}
NR_ENTRIES=${2:-1000}
OUTFILE=${3:-testprojspec.json}

echo "{" > $OUTFILE
echo '  "name": "'$PROJ_NAME'",' >> $OUTFILE
echo '  "receivers": [' >> $OUTFILE

for i in $(seq 1 $NR_ENTRIES); do
  # Generate random Ethereum address (20 bytes hex)
  address="0x$(openssl rand -hex 20)"

  # Generate random amount between 10000 and 10000000
  amount=$(shuf -i 10000-10000000 -n 1)

  # Format as JSON and append to file, with a comma except for the last entry
  if [ $i -lt 1000 ]; then
    echo "  [ \"$address\", \"$amount\" ]," >> $OUTFILE
  else
    echo "  [ \"$address\", \"$amount\" ]" >> $OUTFILE
  fi
done

echo "  ]" >> $OUTFILE
echo "}" >> $OUTFILE
