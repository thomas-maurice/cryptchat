# Generates a random string
randString = (len) ->
    chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@(){}=+*/-.[]°#~&"
    (chars.charAt Math.floor(Math.random()*chars.length) for n in [1..len]).join ''

# Exports for the tests
module.exports.randString = randString
