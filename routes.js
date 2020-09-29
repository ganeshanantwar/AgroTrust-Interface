const express = require('express');
const router = express.Router();
const multichain = require('./multichain.js');
const fs=require('fs');
const path = require('path');

/**
For some crops:
{
    "payload":["GFPCL",["C0000001","C0000002"],"getinfo",[]]
}

For all crops:
{
    "payload":["GFPCL",[],"getinfo",[]]
}

**/

router.post('/', async (req, res) => {
    
    const payload = req.body.payload;

    let cropmap = (JSON.parse(fs.readFileSync(path.resolve('cropmap.json')))).list;
    cropmap=cropmap.filter(i=>i.activated==true);
    if(payload[1].length!=0){
        cropmap=cropmap.filter(j=>payload[1].includes(j.cropID));
    }

    const blockchains=[...new Set(cropmap.map(x=>x.blockchain))];
    let calls=[];
    
    blockchains.forEach(y=>{
        calls.push(multichain(payload[0],y,payload[2],payload[3]));
    });
   

    await Promise.all(calls)
    .then(r => {res.status(200).json(r);})
    .catch(e => e);

});



module.exports = router;