expect = require('chai').expect
should = require('chai').should()
lib = require '../src/static/coffee/lib.coffee'

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
