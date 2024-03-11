import fs from "fs";
import express from 'express';
import bodyParser from 'body-parser';
import { StandardMerkleTree } from "@openzeppelin/merkle-tree";

const app = express();
app.use(bodyParser.json());

// Logic

function getTreeFileName(projName) {
    return `data/${projName}_tree.json`;
}

function getTree(projName) {
    const treeData = fs.readFileSync(getTreeFileName(projName));
    return StandardMerkleTree.load(JSON.parse(treeData));
}

// Persists project data including a merkle tree derived from the receivers array
// TODO: what if the project already exists?
// TODO: handle logo
// TODO: sanitize data
function createProj(name, logo, receivers) {
    if (name === undefined) throw new Error('name is required');
    if (name === "") throw new Error('name cannot be empty');
    const isAlphanumeric = (str) => /^[a-zA-Z0-9]+$/.test(str);
    if (!isAlphanumeric(name)) throw new Error('name must be alphanumeric');

    console.log(`Creating project ${name} with logo ${logo} and receivers ${receivers}`);

    // Create the merkle tree
    const tree = StandardMerkleTree.of(receivers, ["address", "uint256"]);
    console.log('Merkle Root:', tree.root);

    // Persist the merkle tree with project scoped filename
    fs.writeFileSync(getTreeFileName(name), JSON.stringify(tree.dump()));
}

// returns a proof or throws
function genProof(projName, addr) {
    const tree = getTree(projName);
    console.log(`Generating proof for project ${projName}, address ${addr}`);
    for (const [i, v] of tree.entries()) {
        if (v[0] === addr) {
            const proof = tree.getProof(i);
            return {
                value: v,
                proof: proof
            }
        }
    }
    throw new Error("Address not found in merkle tree");
}

// Routes

app.post('/create-proj', (req, res) => {
    const { name, logo, receivers } = req.body;
    try {
        createProj(name, logo, receivers);
        res.status(200).send('OK');
    } catch (e) {
        console.log(`Error: ${e}`);
        res.status(500).send({error: e.message});
    }
});

app.get('/projects/:name/gen-proof/:addr', (req, res) => {
    const { name, addr } = req.params;
    try {
        const proof = genProof(name, addr);
        res.status(200).send(proof);
    } catch (e) {
        console.log(`Error: ${e}`);
        res.status(500).send({error: e.message});
    }
});

app.listen(process.env.PORT || 3000, () => {
    console.log('Server is running on port 3000');
});
