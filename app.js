const express = require('express');
const app=express();
const bodyParser = require("body-parser");
const cors = require('cors');
const port = process.env.PORT || 7000;
const multichainRouter=require('./routes.js');

app.use(cors());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.use('/',multichainRouter);

app.listen(port, () => {
    console.log(`AgroTrust Interface is running on ${port}`);
});