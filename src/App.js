import React from 'react';
import logo from './logo.svg';
import './App.css';

import AWS from 'aws-sdk';

// you shouldn't hardcode your keys in production! See http://docs.aws.amazon.com/AWSJavaScriptSDK/guide/node-configuring.html
AWS.config.update({accessKeyId: 'akid', secretAccessKey: 'secret', region:"us-east-2"});



function App() {
  let lambda = new AWS.Lambda({
    endpoint: 'http://localhost:4566'
  });

  var params = {
    FunctionName: 'helloworld-local-hello', /* required */
    Payload: ""
  };

  lambda.invoke(params, function(err, data) {

    if (err) console.log(err, err.stack); // an error occurred

    else     alert(data.Payload);           // successful response

  });
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Edit <code>src/App.js</code> and save to reload?
        </p>
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React
        </a>
      </header>
    </div>
  );
}

export default App;
