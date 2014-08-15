myRSAKey = undefined
myRandom = undefined
myRSAPubstring = undefined

# Socket.io connection code
socket = io.connect host

# The new user
user = new User()

# Connexion handler
socket.on "connected", (socket) ->
    console.log "connected !"

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
            user.setRSAKey cryptico.generateRSAKey myRandom, 1024
            $('#myRSAPubstring').html(user.getRSAPubstring().replace /([^\n]{32})/g, "$1\n")
            console.log "RSA key computed"
            $('#loadingmodal').modal 'hide'
            
        , 1000
    
    # Tabs initialization code
    $('#myTab a:first').tab 'show'
    $('#myTab a').click (e) ->
        e.preventDefault()
        $(this).tab('show')
