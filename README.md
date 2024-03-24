# Airstream Gadget

## API

Prerequisites: nodejs and yarn installed.

Prepare with
```
cd api
yarn install
```

Then run with
```
yarn start
```
This starts an API server at port 3000.

In order to test, first generate test data
```
./create-test-data.sh
```

This will create a file `testprojspec.json` containing a randomly generated list of receivers and unit amounts.

Now you can create a project via API using that data with
```
curl -X POST -H "Content-Type: application/json" --data-binary "@testprojspec.json" http://localhost:3000/create-proj
```

In order to generate a proof for an account
```
curl http://localhost:3000/projects/test/gen-proof/$(cat testprojspec.json | jq -r ".receivers[0][0]")
```
This creates a proof for the first account in the receivers list.
This entry happens to be an account we have the OK for (see create script), so it can be used for testing claim() in the contract.

Example return data of gen-proof:
```
{"value":["0x2a544e63013c5a60e44aaa46e5f7504c996f5d29","5583690"],"proof":["0x84292ba51a4e647f474084a6fb8fd458651e94e10b70ea9ccd41292ba0c4edaf","0xa7d371e292b866148510dd01515192457ed74926c39be3c1193de06139c4f8de","0xfb89831f398a4b663095a1016f7a2945a3580319be57cf02680220e42a1ccafa","0x53da17c42a7e8bf3a737aa13d7fc981f388d777062e71fffed2c755248691625","0x699a3b97093a6625e0d3e9251b35b1949a0c2e59529ce644feeeadc8d8978780","0xca6a6c1cec5c0235962e3547161b22218c1c78448e0e53ccfb317977ddf3c9eb","0xc28300b358c9b54cf9d9085b3f3ca2f6601fcc045252ba62958bf81854180a91","0x46b82cdc4b479f0ddaea7f5bc5c47e1f0bced9f8a157950c810e44371001cd0f","0xf666fa882407d831ea5d7c6861587e49c141065e90395a7563391551a7e740a1","0x3bbf3bdd1a9b33a7d4fc7ad7ad4b6a56fd0008e9930d0a102f081b4561d9281c"]}
```

## Contract

Prerequisites: [foundry](https://getfoundry.sh/) installed.

Prepare with
```
cd contracts
forge install
```

Run the test with
```
forge test
```

Deploy the factory to optimism-sepolia:
```
./deploy.sh optimism-sepolia MerkleStreamDistributorFactory
```

## Deployments

Factory on optimism-sepolia: 0xeBdFC258ED54c62e770a0F932C0324676a7a3FDB