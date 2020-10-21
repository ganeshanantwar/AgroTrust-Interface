const jayson = require('jayson/promise');
const https = require('https');
const fs = require('fs');
const path = require('path');

module.exports = async (le, chain, method, params) => {
	//const call =  async (le, chain, method, params) => {
	let network = JSON.parse(fs.readFileSync(path.resolve('network.json')));
	let node = network.legalEntities
		.filter((i) => i.LECode == le)[0]
		.chains.filter((j) => j.blockchain == chain)[0];

	const nodeConnection = {
		host: node.host,
		port: node.port,
		auth: node.rpcuser + ':' + node.rpcpass,
		timeout: 60000,
		agent: new https.Agent({
			rejectUnauthorized: true,
			ca: fs.readFileSync(path.resolve('ssl/' + node.cert)),
			servername: node.fqdn,
		}),
	};

	const client = jayson.client.https(nodeConnection);

	return await client
		.request(method, params)
		.then((res) => res.result)
		.catch((err) => {
			let error = { status_code: err.code, error: true };
			if (err.code == 401) {
				error.message = 'Not Authorized!';
			}
			if (err.code == 404 || err.code == 500) {
				error = { ...error, ...JSON.parse(err.toString().substr(7)).error };
			}
			return { ...error };
		});
};
