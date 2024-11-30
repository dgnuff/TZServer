#!/usr/bin/env node

const http = require("http");
const tzInfo = require("./tzinfo");

const host = '0.0.0.0';
const port = 15000;

const requestListener = function (req, res)
{
    var url = new URL("http://path.abc" + req.url);
    tzName = url.searchParams.get("tzname");
    if (tzName == undefined)
    {
        tzNamer = "etc/utc";
    }

    var entry = tzInfo.tzInfo.find(entry =>
        entry.name.localeCompare(tzName, undefined,
        { sensitivity: 'accent' }) === 0);

    if (entry === undefined)
    {
        entry = tzInfo.tzInfo.find(entry => entry.name === "etc/utc");
    }
    console.log("Request: " + tzName);
    console.log("Result:");
    console.log(entry);
    console.log("");

    res.setHeader("Content-Type", "application/json");
    res.writeHead(200);
    res.end(JSON.stringify(entry));
};

const server = http.createServer(requestListener);
server.listen(port, host, () =>
{
    console.log(`Server is running on http://${host}:${port}`);
});



