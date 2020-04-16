'use strict';
const shim = require('fabric-shim');
const util = require('util');

/**
 * Executes a query using a specific key
 * 
 * @param {*} key - the key to use in the query
 */
async function queryByKey(stub, key) {
  console.log('============= START : queryByKey ===========');
  console.log('**** queryByKey key: ' + key);

  let resultAsBytes = await stub.getState(key); 
  if (!resultAsBytes || resultAsBytes.toString().length <= 0) {
    throw new Error('**** queryByKey key: ' + key + ' does not exist');
  }
  console.log('**** queryByKey response: ' + resultAsBytes);
  console.log('============= END : queryByKey ===========');
  return resultAsBytes;
}

/**
 * Executes a query based on a provided queryString
 * 
 * @param {*} queryString - the query string to execute
 */
async function queryByString(stub, queryString) {
  console.log('============= START : queryByString ===========');
  console.log("**** queryByString queryString: " + queryString);

  let docType = "";
  let startKey = "";
  let endKey = "";
  let jsonQueryString = JSON.parse(queryString);
  if (jsonQueryString['selector'] && jsonQueryString['selector']['docType']) {
    docType = jsonQueryString['selector']['docType'];
    startKey = docType + "0";
    endKey = docType + "z";
  }
  else {
    throw new Error('**** queryByString - Cannot call queryByString without a docType element: ' + queryString);   
  }

  let iterator = await stub.getStateByRange(startKey, endKey);

  let allResults = [];
  while (true) {
    let res = await iterator.next();

    if (res.value && res.value.value.toString()) {
      let jsonRes = {};
      console.log('**** queryByString iterator: ' + res.value.value.toString('utf8'));

      jsonRes.Key = res.value.key;
      try {
        jsonRes.Record = JSON.parse(res.value.value.toString('utf8'));
      } 
      catch (err) {
        console.log('**** queryByString error: ' + err);
        jsonRes.Record = res.value.value.toString('utf8');
      }

      let jsonRecord = jsonQueryString['selector'];
      // If there is only a docType, no need to filter, just return all
      console.log('**** queryByString jsonRecord - number of JSON keys: ' + Object.keys(jsonRecord).length);
      if (Object.keys(jsonRecord).length == 1) {
        allResults.push(jsonRes);
        continue;
      }
      for (var key in jsonRecord) {
        if (jsonRecord.hasOwnProperty(key)) {
          console.log('**** queryByString jsonRecord key: ' + key + " value: " + jsonRecord[key]);
          if (key == "docType") {
            continue;
          }
          console.log('**** queryByString json iterator has key: ' + jsonRes.Record[key]);
          if (!(jsonRes.Record[key] && jsonRes.Record[key] == jsonRecord[key])) {
            // we do not want this record as it does not match the filter criteria
            continue;
          }
          allResults.push(jsonRes);
        }
      }
    }
    if (res.done) {
      await iterator.close();
      console.log('**** queryByString all results: ' + JSON.stringify(allResults));
      console.log('============= END : queryByString ===========');
      return Buffer.from(JSON.stringify(allResults));
    }
  }
}

/************************************************************************************************
 * CHAINCODE
 ************************************************************************************************/

let Chaincode = class {

  async Init(stub) {
    console.log('=========== Init: Instantiated / Upgraded chaincode ===========');
    return shim.success();
  }

  async Invoke(stub) {
    console.log('============= START : Invoke ===========');
    let ret = stub.getFunctionAndParameters();
    console.log('**** Invoke args: ' + JSON.stringify(ret));

    let method = this[ret.fcn];
    if (!method) {
      console.error('**** Invoke - error: no chaincode function with name: ' + ret.fcn + ' found');
      throw new Error('No chaincode function with name: ' + ret.fcn + ' found');
    }
    try {
      let response = await method(stub, ret.params);
      console.log('**** Invoke response payload: ' + response);
      return shim.success(response);
    } catch (err) {
      console.log('**** Invoke - error: ' + err);
      return shim.error(err);
    }
  }

  /************************************************************************************************
   * Patient functions 
   ************************************************************************************************/

   /**
   * Creates a new Patient
   * 
   * @param {*} stub 
   * @param {*} args - JSON as follows:
   * {
   *    "donorUserName":"edge",
   *    "email":"edge@abc.com",
   *    "registeredDate":"2018-10-22T11:52:20.182Z"
   * }
   */
  async createPatient(stub, args) {
    console.log('============= START : createPatient ===========');
    console.log('**** createPatient arguments: ' + JSON.stringify(args));

    // args is passed as a JSON string
    let json = JSON.parse(args);
    let key = 'donor' + json['donorUserName'];
    json['docType'] = 'donor';

    console.log('**** createPatient payload: ' + JSON.stringify(json));

    await stub.putState(key, Buffer.from(JSON.stringify(json)));
    console.log('============= END : createPatient ===========');
  }

  async queryPatient(stub, args) {
    console.log('============= START : queryPatient ===========');
    console.log('**** queryPatient arguments: ' + JSON.stringify(args));

    // args is passed as a JSON string
    let json = JSON.parse(args);
    let key = 'donor' + json['donorUserName'];
    console.log('**** queryPatient key: ' + key);

    return queryByKey(stub, key);
  }

  async queryAllPatients(stub, args) {
    console.log('============= START : queryAllPatients ===========');
    console.log('**** queryAllPatients arguments: ' + JSON.stringify(args));
 
    let queryString = '{"selector": {"docType": "donor"}}';
    return queryByString(stub, queryString);
  }

}

shim.start(new Chaincode());