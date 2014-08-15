myRSAKey = undefined
myRandom = undefined
myRSAPubstring = undefined

# Socket.io connection code
socket = undefined

# The new user
user = new User()

# Connexion handler
socketOnConnected = (s) ->
    console.log "connected !"

socketOnContactID = (s, id) ->
    $('#contactid').html '<pre>'+id+'</pre>'

newIdentity = ->
    myRandom = randString 64
    user = new User()
    console.log "Computing RSA key"
    user.setRSAKey cryptico.generateRSAKey myRandom, 1024
    $('#myRSAPubstring').html(user.getRSAPubstring().replace /([^\n]{32})/g, "$1\n")
    console.log "RSA key computed"
    $('#loadingmodal').modal 'hide'
    if socket != undefined
        socket.io.disconnect()
        socket.io.reconnect()
    else
        socket = io.connect(host)
        socket.on "connected", () ->
            socketOnConnected(socket)
        socket.on "contactid", (id) ->
            socketOnContactID(socket, id)

# Initialization code for jQuery
$ ->
    $('#loadingmodal').modal
        keyboard: false
        show: false
    
    $('#loadingmodal').modal 'show'
    
    setTimeout () ->
            newIdentity()
        , 1000
    
    # Tabs initialization code
    $('#myTab a:first').tab 'show'
    $('#myTab a').click (e) ->
        e.preventDefault()
        $(this).tab('show')
    
    $('#newidentity').click ->
        $('#loadingmodal').modal 'show'
        setTimeout () ->
                newIdentity()
            , 1000
