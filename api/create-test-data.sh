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
  index=$i
  # as first address, set 0xaaaa376498c404044723c532458d68552763c860
  # its pk is f9d8916ae9e8b4e2c97a32166ee113658905fb7d92499b0faae838a8827cacc9
  if [ $i -eq 1 ]; then
    address="0xaaaA376498C404044723C532458D68552763C860"
    amount=10000000
    echo "  [ \"$index\", \"$address\", \"$amount\" ]," >> $OUTFILE
    continue
  fi

  # Generate random Ethereum address (20 bytes hex)
  address="0x$(openssl rand -hex 20)"

  # Generate random amount between 10000 and 10000000
  amount=$(shuf -i 10000-10000000 -n 1)

  # Format as JSON and append to file, with a comma except for the last entry
  if [ $i -lt $NR_ENTRIES ]; then
    echo "  [ \"$index\", \"$address\", \"$amount\" ]," >> $OUTFILE
  else
    echo "  [ \"$index\", \"$address\", \"$amount\" ]" >> $OUTFILE
  fi
done

echo "  ]" >> $OUTFILE
echo "}" >> $OUTFILE
