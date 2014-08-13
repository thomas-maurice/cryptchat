#!/bin/bash

if [ -z `which npm` ]; then
	echo "You must install npm !"
	exit 1
fi

if [ -z `which bower` ]; then
	echo "You must install bower ! run as root :"
	echo " $ npm install -g bower"
	exit 1
fi

if [ -z `which mocha` ]; then
	echo "You must install mocha ! Run this as root :"
	echo "npm install -g mocha"
	exit 1
fi

echo "Building the project..."
npm install
bower install
npm test
grunt
echo "Done"
