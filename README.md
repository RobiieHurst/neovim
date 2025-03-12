---
id: 1740729588-crypto-imports
aliases: []
tags:
  - issue
---

# Crypto import global

## Findings

I was mistaken that the crypto module that we are using is the same one that has now been made global in node

There are two different apis.

### [node crypto](https://nodejs.org/api/crypto.html#crypto>)

The `node:crypto` module provides cryptographic functionality that includes a set of wrappers for OpenSSL's hash, HMAC, cipher, decipher, sign, and verify functions.

### [web crypto](https://nodejs.org/api/webcrypto.html#web-crypto-api)

    Is an implementation of the standard [Web Crypto API](https://www.w3.org/TR/WebCryptoAPI/).

## Conclusion

For our current use case where we perform all of this authenticationa and key generation we should use what we are currently using and make 0 changes.
