const express = require('express');
const router = express.Router();
const multichain = require('./multichain.js');
const fs = require('fs');
const path = require('path');

/**
For specific crops:
{
    "payload":["GFPCL",["c001","0002"],"getinfo",[]]
}

For all crops:
{
    "payload":["GFPCL",[],"getinfo",[]]
}

**/

router.post('/', async (req, res) => {
	const payload = req.body.payload;

	//Read activated crops from cropmap.json config file
	let cropmap = JSON.parse(fs.readFileSync(path.resolve('cropmap.json'))).cropmap;
	cropmap = cropmap.filter((i) => i.activated == true);

	//Filter cropmap for crop IDS reeceived in the request
	if (payload[1].length != 0) {
		cropmap = cropmap.filter((j) => payload[1].includes(j.cropID));
	}

	//Resolve blockchains for requested crop IDs
	const blockchains = [...new Set(cropmap.map((x) => x.blockchain))];
	let calls = [];

	//Call each blockchain for Multichain API call reeceived in the request
	blockchains.forEach((y) => {
		calls.push(multichain(payload[0], y, payload[2], payload[3]));
	});

	await Promise.all(calls)
		.then((r) => {
			res.status(200).json(r);
		})
		.catch((e) => e);
});

module.exports = router;
