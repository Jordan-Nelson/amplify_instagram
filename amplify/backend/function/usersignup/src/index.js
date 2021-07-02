/* Amplify Params - DO NOT EDIT
	API_AMPLIFYINSTAGRAM_GRAPHQLAPIENDPOINTOUTPUT
	API_AMPLIFYINSTAGRAM_GRAPHQLAPIIDOUTPUT
	ENV
	REGION
Amplify Params - DO NOT EDIT */

const https = require('https');
const AWS = require("aws-sdk");
const urlParse = require("url").URL;
const appsyncUrl = process.env.API_AMPLIFYINSTAGRAM_GRAPHQLAPIENDPOINTOUTPUT;
const region = process.env.REGION;
const endpoint = new urlParse(appsyncUrl).hostname.toString();
const graphqlQuery = require('./query.js').mutation;
const apiKey = process.env.API_AMPLIFYINSTAGRAM_GRAPHQLAPIKEYOUTPUT;

exports.handler = async (event, context) => {
    console.log('API_AMPLIFYINSTAGRAM_GRAPHQLAPIENDPOINTOUTPUT', process.env.API_AMPLIFYINSTAGRAM_GRAPHQLAPIENDPOINTOUTPUT)
    console.log('name', event.request.userAttributes.name)
    console.log('preferred_username', event.request.userAttributes.preferred_username)

    const req = new AWS.HttpRequest(appsyncUrl, region);

    const item = {
        input: {
            name: event.request.userAttributes.name,
            username: event.request.userAttributes.preferred_username
        }
    };

    req.method = "POST";
    req.path = "/graphql";
    req.headers.host = endpoint;
    req.headers["Content-Type"] = "application/json";
    req.body = JSON.stringify({
        query: graphqlQuery,
        operationName: "createUser",
        variables: item
    });

    if (apiKey) {
        req.headers["x-api-key"] = apiKey;
    } else {
        const signer = new AWS.Signers.V4(req, "appsync", true);
        signer.addAuthorization(AWS.config.credentials, AWS.util.date.getDate());
    }

    const data = await new Promise((resolve, reject) => {
        const httpRequest = https.request({ ...req, host: endpoint }, (result) => {
            let data = "";

            result.on("data", (chunk) => {
                console.log('data received');
                data += chunk;
            });

            result.on("end", () => {
                console.log('request ended');
                console.log('data', data);
                resolve(JSON.parse(data.toString()));
            });
        });

        httpRequest.write(req.body);
        httpRequest.end();
    });
    console.log('final data', data);
    context.done(null, event);
};