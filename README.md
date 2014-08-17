# cryptchat
A cryptographic Javascript chat client.

The aim of the app is to provide a **temporary** and secure channel of communication
between two people. The conversation will be entirely anonymous and encrypted.
The cipher and decipher operations will be performed on the clients, that mean that
the server will transmit messages, but having **zero knowledge** of the message's
content.

## Basic information about the asymetric cipher
The principle is simple. You generate two keys, one public and one private.
The public one is given to all your contacts, it is used to send you messages
once a message is encrypted with it, it cannot be decrypted back. The private key
is used by you to decrypt the messages. No one can have it.

This chat is based on this technology, so you are the only one to be able
to decrypt the messages that are sent to you. Isn't it cool ?

## Developpement information
 * Developper : svartbergtroll
 * Version : v0.0.3
 * Stability : Not functionnal yet

## License
               DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                       Version 2, December 2004
     
    Copyright (C) 2014 Thomas Maurice <tmaurice59@gmail.com>
    
    Everyone is permitted to copy and distribute verbatim or modified
    copies of this license document, and changing it is allowed as long
    as the name is changed.
     
               DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
      TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
     
     0. You just DO WHAT THE FUCK YOU WANT TO.


## Building
To build it you will need

 * npm
 * bower `npm install -g bower`
 * grunt `npm install -g grunt-cli`
 * mocha `npm install -g mocha` (for the tests)

Then run `./build.sh` then `grunt deploy` to deploy the app !

## As a user
When you connect to the app, you will automatically generate a RSA key which
will be user to encrypt your messages. At the same time the server will
attribute you an ID. This ID is hopefully unique and will be the only identification
information you will need to transmit to people you want to chat with.

**Warning**: This ID is attributed as soon as you log into the server. In
order to ensure the unicity and integrity of your ID, the server chooses it.
That means that if at any time you loose connexion, you reload the page and
so on, you will be attributed a new ID, and all your previous discussions will
be closed, so you will have to transmit again your ID to your contacts.

A typical chat session proceeds as it follows :

 * You transmit your ID to someone
 * He logs in and enters it, and hit "New chat"
 * A notification is sent to you, containing is public key.
 * You automatically send you your own public key
 * The chat can begin
