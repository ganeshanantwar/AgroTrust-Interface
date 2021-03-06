#!/bin/bash

BLOCKCHAIN=(agrotrust-citrus agrotrust-leafy agrotrust-cucurbits)
RPC=7001
NETWORK=6001

for i in "${BLOCKCHAIN[@]}"
do 


multichain-util create $i --default-network-port=$NETWORK --default-rpc-port=$RPC

openssl genrsa -out ~/.multichain/$i/$i.pem 2048

openssl req -new -x509 -nodes -sha1 -days 3650 -subj "/C=IN/ST=Maharashtra/L=Mumbai/O=Emertech Innovations Pvt Ltd/OU=Agrotrust/CN=agrotrust.io" -key ~/.multichain/$i/$i.pem > ~/.multichain/$i/$i.cert

echo "rpcuser=rpcuser-"$RPC >  ~/.multichain/$i/multichain.conf
echo "rpcpassword=rpcpass-"$RPC >>  ~/.multichain/$i/multichain.conf
echo "rpcssl=1" >>  ~/.multichain/$i/multichain.conf
echo "rpcallowip=0.0.0.0/0" >>  ~/.multichain/$i/multichain.conf
echo "rpcsslciphers=DEFAULT:@STRENGTH" >>  ~/.multichain/$i/multichain.conf
echo "rpcsslcertificatechainfile=$i.cert" >>  ~/.multichain/$i/multichain.conf
echo "rpcsslprivatekeyfile=$i.pem" >>  ~/.multichain/$i/multichain.conf

sed -i -e 's/max-std-op-returns-count = 32/max-std-op-returns-count = 1024/g' ~/.multichain/$i/params.dat

sed -i -e 's/mining-diversity = 0.3/mining-diversity = 0.66/g' ~/.multichain/$i/params.dat

multichaind $i -daemon

sleep 5

cp ~/.multichain/$i/$i.cert ~/AgroTrust_1.0/multichain-interface/ssl

multichain-cli $i create stream idmap '{"restrict":"onchain,write"}'
multichain-cli $i create stream farmer '{"restrict":"onchain,write"}'
multichain-cli $i create stream farmer-hashmap '{"restrict":"onchain,write"}'
multichain-cli $i create stream origin '{"restrict":"onchain,write"}'
multichain-cli $i create stream origin-hashmap '{"restrict":"onchain,write"}'
multichain-cli $i create stream material '{"restrict":"onchain,write"}'
multichain-cli $i create stream material-hashmap '{"restrict":"onchain,write"}'
multichain-cli $i create stream sku '{"restrict":"onchain,write"}'
multichain-cli $i create stream sku-hashmap '{"restrict":"onchain,write"}'
multichain-cli $i create stream location '{"restrict":"onchain,write"}'
multichain-cli $i create stream location-hashmap '{"restrict":"onchain,write"}'
multichain-cli $i create stream btu '{"restrict":"onchain,write"}'
multichain-cli $i create stream transfer '{"restrict":"onchain,write"}'

multichain-cli $i subscribe idmap
multichain-cli $i subscribe farmer
multichain-cli $i subscribe farmer-hashmap
multichain-cli $i subscribe origin
multichain-cli $i subscribe origin-hashmap
multichain-cli $i subscribe material
multichain-cli $i subscribe material-hashmap
multichain-cli $i subscribe sku
multichain-cli $i subscribe sku-hashmap
multichain-cli $i subscribe location
multichain-cli $i subscribe location-hashmap
multichain-cli $i subscribe btu
multichain-cli $i subscribe transfer

#FARMER Codes Range: 0xFA000001 to 0xFAFFFFFF
multichain-cli $i publish idmap farmer fa000000 offchain
multichain-cli $i publish farmer-hashmap fa000000 0000000000000000000000000000000000000000000000000000000000000000 offchain

#ORIGIN Codes Range: 0xFE000001 to 0xFEFFFFFF
multichain-cli $i publish idmap origin fe000000 offchain
multichain-cli $i publish origin-hashmap fe000000 0000000000000000000000000000000000000000000000000000000000000000 offchain

#LOCATION Codes Range: 0xAB000001 to 0xABFFFFFF
multichain-cli $i publish idmap location ab000000 offchain
multichain-cli $i publish location-hashmap ab000000 0000000000000000000000000000000000000000000000000000000000000000 offchain

#MATERIAL Codes Range: 0xC0010001 to 0xCFFFFFFF
#Where Crop IDs from C001 to CFFF
#And Variety IDs from 0001 to FFFF
multichain-cli $i publish idmap material c0000000 offchain
multichain-cli $i publish material-hashmap c0000000 0000000000000000000000000000000000000000000000000000000000000000 offchain

#SKU Codes Range: 0xEA000001 to 0xEAFFFFFF
multichain-cli $i publish idmap sku ea000000 offchain
multichain-cli $i publish sku-hashmap ea000000 0000000000000000000000000000000000000000000000000000000000000000 offchain

#BTU Codes Range: 0x10000001 to 0x4FFFFFFF
multichain-cli $i publish idmap btu 10000000 offchain

#TRANSFER Codes Range: 0x50000001 to 0x8FFFFFFF
multichain-cli $i publish idmap transfer 40000000 offchain


RPC=$((RPC+1))
NETWORK=$((NETWORK+1))
done