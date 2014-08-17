# Definition of the User class

# Requires to have the cryptico functions loaded.

class User
    # User constructor
    constructor: ->
        @nickname = undefined
        @RSAKey = undefined
        @id = undefined
    
    setNickname: (nick) ->
        @nickname = nick
    
    getNickname: ->
        @nickname
    
    setID: (id) ->
        @id = id
    
    getID: ->
        @id
    
    
    setRSAKey: (key) ->
        @RSAKey = key
    
    getRSAKey: ->
        @RSAKey
    
    # IT must return "" when there is nor RSAKey specified
    getRSAPubstring: ->
        return "" if @RSAKey == undefined
        return cryptico.publicKeyString @RSAKey
    


# Exports for the tests
# If jquery is defined then do nothing bellow
# Kind of dirty but I have no clue about how doing
# it in an other way
if(!$?)
    module.exports.User = User
