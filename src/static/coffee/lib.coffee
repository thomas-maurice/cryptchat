# Generates a random string
randString = (len) ->
    chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@(){}=+*/-.[]°#~&"
    (chars.charAt Math.floor(Math.random()*chars.length) for n in [1..len]).join ''

# Exports for the tests
# If jquery is defined then do nothing bellow
if(!$?)
    module.exports.randString = randString
