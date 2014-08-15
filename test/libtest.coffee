expect = require('chai').expect
should = require('chai').should()
lib = require '../src/static/coffee/lib.coffee'
user = require '../src/static/coffee/user.coffee'

# Test the clientside library
describe 'Clientside library', ->
    describe '#randString', ->
        it 'Should give a string of the correct length', ->
            len = Math.round(Math.random()*30)+10
            s = lib.randString len
            s.should.have.length len
        it 'Should return two different strings when called twice', ->
            len = Math.round(Math.random()*30)+10
            s1 = lib.randString len
            s2= lib.randString len
            s1.should.not.equals s2

# Test the User class
describe 'User class', ->
    u = undefined
    before ->
        u = new user.User()
    
    describe '#constructor', ->
        it 'Should give an undefined nickname', ->
            (u.getNickname() == undefined).should.be.true
        it 'Should give an undefined RSAKey', ->
            (u.getRSAKey() == undefined).should.be.true
    
    describe '#setNickname', ->
        it 'Should properly set the nickname', ->
            u.setNickname "toto"
            u.getNickname().should.equal("toto")
    
    describe '#getRSAPubstring', ->
        it 'Should return empty when there is no RSAKey', ->
            u.getRSAPubstring().should.equal("")
