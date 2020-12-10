# AGROTRUST INTERFACE

-  AgroTrust describes and mandates a decentralized architecture to model any agricultural value chain of arbitrary complexity. Each organization on-boarded on the blockchain network runs three NodeJS processes viz. AgroTrust Interface, AgroTrust Master, AgroTrust QRiosity and any crop blockchains that the organization is involved in.
-  In production workloads, the blockchain processes and AgroTrust Interface should be run on the Transaction Node while AgroTrust Master and QRiosity should be run on Application Node.
-  For testing purposes, all processes could be run on localhost by simply downloading and running 'node app.js' on the terminal. The development of a publicaly available Test Network for all major crops is in development, until then testing on localhost is encouraged.

### Which blockchain protocol is used in AgroTrust?

-  AgroTrust uses Multichain 2.0, a private blockchain protocol. Multichain is a fork of Bitcoin Core enhanced for permissioned blockchains and known for its speed and ease of deployment.
-  Multichain provides unlimited blockchains per server for cross chain applications fitting nicely into AgroTrust’s ‘One Crop, One Blockchain’ model.
-  It allows creation of on-chain assets that are tracked and verified at network level. Each food product can be represented by an asset. It can also perform safe multi-asset and multi-party atomic exchange transactions which can represent buying and selling of food products.
-  Multichain has streams (on-chain and off-chain) which are key-value data stores with timestamps and publisher identity. Streams are a perfect tool to record product metadata.
-  Multichain allows fine grained permissions control at address, asset and stream level making it possible to implement nodes for parties in fragmented food value chains without compromising data privacy and security.
-  The consensus mechanism used in Multichain protocol is a randomized round-robin validation based on distributed consensus between permissioned block validators similar to PBFT. This algorithm is called Mining Diversity.
-  With diversity set to 0, any validator can add a block. This is very tolerant but also increases the risk that a single or small group of validators can compromise the system.
-  With the diversity setting of 1, once a block is added by a validator, every other validator needs to add a block before the original one can add the block again. This stops a single or a group of validators from creating forks, but if a node goes offline then at some point no further blocks can be added while the network waits for that node, possibly infinitely, freezing the blockchain.
-  Hence the diversity setting scale lets you choose the balance between Byzantine security and technical malfunction risk. Mining Diversity does not provide transaction finality, so forks can occur.

### What is this repository for?

-  Quick summary: Because one organization can contain multiple legal entities and be involved in multiple crops, AgroTrust Interface provides a single connector API which resolves calls from application node. It translates requests into corresponding multichain APIs, directs them to the correct blockchain and returns a response.

-  Version : 0.1.0

### How do I get set up?

Below instructions assume Linux nodes and have been thoroughly tested on Ubuntu 18.04 LTS.
These instructions define a testing setup with two dummy LEs and three crop blockchains.

-  Configuration

1. network.json configuration file describes legal entities and crop blockchains each LE is involved in.

Organization: Green Farms
LEs: GFPCL and GRPL

2. cropmap.json configuration file describes a mapping between blockchains and crops, following the principle of 'One Crop, One Blockchain'. When crops are closely related, they can be merged into a higher level in the botanical classification e.g. Cucurbits and Citrus. But a crop with large production, like Wheat or Cotton, should have a separate blockchain.

Crop Blockchains: agrotrust-citrus, agrotrust-leafy, agrotrust-cucurbits

-  Setup instructions

1. Download Multichain 2.0 Community Edition binaries from the official site. Version: March 25, 2019 – Version 2.0 (release) for Linux and Windows. https://www.multichain.com/download-community/

Use following commands to install Multichain Blockchain Runtime:

su (enter root password)
cd /tmp
wget https://www.multichain.com/download/multichain-2.0-release.tar.gz
tar -xvzf multichain-2.1.1.tar.gz
cd multichain-2.1.1
mv multichaind multichain-cli multichain-util /usr/local/bin

2. Clone this repo at desired location
3. Open terminal and run 'npm install'
4. Run multichain-init.sh bash script. This script will launch three example crop blockchains, configure blockchain parameters and create required streams.
5. multichaind blockchain processes are launched on TCP Ports from 6001 and RPC ports from 7001 onward
6. cd into ~/.multichain directory it should show three folders named agrotrust-_ for each blockchain. Copy agrotrust-_.cert certificate file from each folder into the ./ssl folder of this repository. PLEASE REPLACE WITH NEWLY GENERATED SSL CERTIFICATES OTHERWISE THE INTERFACE WILL NOT CONNECT TO THE BLCOKCHAINS.
7. Run node app.js launching AgroTrust Interface on TCP port 7000.

-  Dependencies

Please refer to package.json

-  Testing the Setup

Send a POST request to http://localhost:7000 with below request body. Response for getinfo Multichain API should be returned for blockchains containing requested crop IDs. If the crop ID array is left blank in the request, API responses from ALL blockchains are returned.

{
"payload":[
"GFPCL", //LE Refname from network.json
["c001","c003","c005"], // Array of crop IDs from cropmap.json
"getinfo", // Multichain internal RPC API method
[] // Multichain internal RPC API parameters
]
}

### Contribution guidelines

-  Writing tests
-  Code review
-  Other guidelines

### Who do I talk to?

-  Repo owner: Ganesh Anantwar, email: ganesh@emertech.io, github: @ganeshanantwar
-  Admin: Danish Siraj, email: danish@emertech.io, github: @dan-19
