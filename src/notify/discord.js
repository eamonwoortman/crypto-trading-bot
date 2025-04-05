const request = require('request');

module.exports = class Discord {
  constructor(config) {
    this.config = config;
  }

  send(message) {
    const postOptions = {
      uri: this.config.webhook,
      method: 'POST',
      headers: {
        'Content-type': 'application/json'
      },
      json: {
        content: message
      }
    };
    request(postOptions, (error, response, body) => {
      if (error) {
        console.log('[Discord] ', error);
      }
    });
  }
};
