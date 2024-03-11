# Airstream Gadget

## API

Run with `yarn start`.
This starts an API server at port 3000.

Test commands for project _testproj_ (json file with example data included):

Create testproj:
```
curl -X POST -H "Content-Type: application/json" --data-binary "@testproj-create-data.json" http://localhost:3000/create-proj
```

generate proof:
```
curl http://localhost:3000/projects/testproj/gen-proof/0xc4ec09837c072979166a7cf24525735b1533ce6f
```

Example return data of gen-proof:
```
{"value":["0xc4ec09837c072979166a7cf24525735b1533ce6f","300000000"],"proof":["0xc19738ba732d66da3969546dc15d5fc7763ce6848bf3e00238b0cc467f477a07"]}
```

## Test accounts

acc 1:
secret:  d1b97b57b42c27fa96967917ce9ab7940328ca9d32045d6e583f573c8388ac89
public:  a257f6a70a660bb7b6d78050d495438215bafbbf9f258a45732b9b5feb9d9754e36460eca4e799ac45f1767fd983eb7fd27d52d6353e7c98d9ca6b343b842bab
address: 844ffe25b213d26af349095ec9e8401341ffd52e

acc 2:
secret:  1de922b8b64b89ff21c903b3d951b8e2b8107e8a98d73bd70cf1a70942deef7f
public:  de38b6d45d8653f30100aa40fdda548e82408cf6a2a8809d0cacc8d183943d4231936a098a646f1e00bef8cf26202d6f9e550ed1e2dc59973b83e2bc3940260b
address: c4ec09837c072979166a7cf24525735b1533ce6f
