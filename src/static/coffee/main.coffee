myRSAKey = undefined
myRandom = undefined
myRSAPubstring = undefined

# Socket.io connection code
socket = io.connect host

# Connexion handler
socket.on "connected", (socket) ->
    console.log "connected !"

# Generates a random string
randString = (len) ->
    chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@(){}=+*/-.[]°#~&"
    (chars.charAt Math.floor(Math.random()*chars.length) for n in [0..len]).join ''

# Initialization code for jQuery
$ ->
    myRandom = randString 64
    $('#loadingmodal').modal
        keyboard: false
        show: false
    
    $('#loadingmodal').modal 'show'
    
    setTimeout () ->
            # Generates the RSA key
            console.log "Computing RSA key"
            myRSAKey = cryptico.generateRSAKey myRandom, 1024
            myRSAPubstring = cryptico.publicKeyString myRSAKey
            $('#myRSAPubstring').html(myRSAPubstring.replace /([^\n]{32})/g, "$1\n")
            console.log myRSAPubstring.replace /([^\n]{32})/g, "$1\n"
            console.log "RSA key computed"
            $('#loadingmodal').modal 'hide'
        , 1000
    
    # Tabs initialization code
    $('#myTab a:first').tab 'show'
    $('#myTab a').click (e) ->
        e.preventDefault()
        $(this).tab('show')
