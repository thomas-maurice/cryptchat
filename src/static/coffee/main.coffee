myRSAKey = undefined
myRandom = undefined
myRSAPubstring = undefined

# Templates list.
# They are loaded when the page is loaded. This dict will contain :
# * chatwindow
templates = {}

discussions = {}

#
# \brief Smiley substitution
# These will be used to substitute smileys. To add
# some just add an array to the array with the format :
# ['pattern', 'replacement'],
#
smileySubstitutions = [
    # Spinning one !
    [":))", "fa-smile-o fa-spin"],
    [":((", "fa-frown-o fa-spin"],
    
    # Like !
    ["(y)", "fa-thumbs-up text-success"],
    ["(n)", "fa-thumbs-down text-danger"],
    
    # Standard one
    [":)", "fa-smile-o"],
    [":-)", "fa-smile-o"],
    [":]", "fa-smile-o"],
    [":-]", "fa-smile-o"],
    [":-/", "fa-meh-o"],
    [":-|", "fa-meh-o"],
    [":|", "fa-meh-o"],
    [":(", "fa-frown-o"],
    [":-(", "fa-frown-o"],
    [":[", "fa-frown-o"],
    [":-[", "fa-frown-o"],
    ["&lt;3", "fa-heart text-danger"],
]

# Socket.io connection code
socket = undefined

# The new user
user = new User()

# Connexion handler
socketOnConnected = (s) ->
    console.log "connected !"

# Disconnexion handler
socketOnDisconnect = (s) ->
    user.setID undefined
    $('#contactid').html '<p class="bg-warning text-warning"><strong>Warning </strong> You are curently disconnected from the server</p>'

# On a contact id change
socketOnContactID = (s, id) ->
    user.setID id
    $('#contactid').html '<pre>'+id+'</pre>'

# On a chat request
socketOnChatRequest = (s, request) ->
    s.emit("chatresponse", {source: user.getID(), dest: request.source, pubkey: user.getRSAPubstring()})
    discussions[request.source] = {pubkey: request.pubkey}
    return if $('#'+request.source).length != 0
    id = request.source
    createNewTab(id)

# On a chat request
socketOnChatResponse = (s, request) ->
    discussions[request.source] = {pubkey: request.pubkey}

# On a chat request
socketOnMessage = (s, msg) ->
    console.log msg
    msg.message = cryptico.decrypt(msg.message, user.getRSAKey()).plaintext
    console.log msg
    displayMessage(msg.source, formatMessage(msg));

# On an error
socketOnError = (s, msg) ->
    if msg.type = "NOSUCHID"
        displayMessage(msg.source, formatError({"message": "The ID `" + msg.source + "` does not exist \
            *maybe* he has disconnected or you typed it wrong ?"}))

# Creates a new tab with a given ID
createNewTab = (id) ->
    $('#tablist').append '<li class="contact '+id+'"><a href="#'+id+'" role="tab" data-toggle="tab">'+id+'</a></li>'
    $('#tabs').append '<div class="tab-pane fade chattab" id="'+id+'"><div class="content"></div></div>'
    $('#'+id+" .content").html swig.render templates['chatwindow'], {locals: {"id": id}}

# Formats a message
formatMessage = (msg) ->
    htmlmessage = markdown.toHTML(msg.message).remove("<p>").remove("</p>");
    # And now smileytize it :)
    for i in [0..smileySubstitutions.length-1]
        while htmlmessage.has smileySubstitutions[i][0]
            htmlmessage = htmlmessage.replace(smileySubstitutions[i][0],
            '<i class="fa '+smileySubstitutions[i][1]+' fa-lg" />');
        
    htmlmessage = htmlmessage.replace(/(https?:\/\/[^\s]+)/g, '<a href="$1" target="_blank">$1</a>');
    return '<font color="blue"><i class="fa fa-comment"></i> <strong>'\
    + msg.source + '</strong></font></span><span class="text-muted"> : ' + htmlmessage + '</span>';

# Formats an error
formatError = (msg) ->
    htmlmessage = markdown.toHTML(msg.message).remove("<p>").remove("</p>");
    # And now smileytize it :)
    for i in [0..smileySubstitutions.length-1]
        while htmlmessage.has smileySubstitutions[i][0]
            htmlmessage = htmlmessage.replace(smileySubstitutions[i][0],
            '<i class="fa '+smileySubstitutions[i][1]+' fa-lg" />');
        
    htmlmessage = htmlmessage.replace(/(https?:\/\/[^\s]+)/g, '<a href="$1" target="_blank">$1</a>');
    return '<span class="bg-danger text-danger"><font color="red"><i class="fa fa-times"></i> <strong>'\
    + 'Error' + '</strong></font> : ' + htmlmessage + '</span>';

# Display a message
displayMessage = (id, msg) ->
    date = new Date();
    horo = "[" + Date.create().format('{24hr}:{mm}:{ss}') + "]";
    
    message = '<div><span>' + horo + "</span> " + msg + '</div>';
    $('#chat-'+id).prepend message;

# Sends a message to a user
sendMessageTo = (id) ->
    message = $('#message-'+id).val()
    return if message == ""
    msg = {};
    encrypt = cryptico.encrypt message, discussions[id].pubkey, user.getRSAKey()
    msg.message = encrypt.cipher
    msg.dest = id
    msg.source = user.getID()
    msg.pubkey = user.getRSAPubstring()
    
    socket.emit("message", msg);
    
    msg.message = message
    
    displayMessage(id, formatMessage(msg));
    $('#message-'+id).val ''

# Closes a discussion by ID
closeDiscussion = (id) ->
    $("#tablist ." + id).remove()
    $("#tabs #" + id).remove()
    discussions[id] = undefined
    $('#tablist a:first').tab 'show'

# Generates a new identity
newIdentity = ->
    $('.chattab').remove()
    $('.contact').remove()
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
    socket.on "disconnect", () ->
        socketOnDisconnect(socket)
    socket.on "contactid", (id) ->
        socketOnContactID(socket, id)
    socket.on "chatrequest", (request) ->
        socketOnChatRequest(socket, request)
    socket.on "chatresponse", (request) ->
        socketOnChatResponse(socket, request)
    socket.on "err", (msg) ->
        socketOnError(socket, msg)
    socket.on "message", (message) ->
        socketOnMessage(socket, message)

# Initialization code for jQuery
$ ->
    # Load templates
    $.ajax
        url: "/static/templates/chatwindow.html"
        success: (res) ->
            templates['chatwindow'] = res
            
    $('#loadingmodal').modal
        keyboard: false
        show: false
    
    $('#loadingmodal').modal 'show'
    
    setTimeout () ->
            newIdentity()
        , 1000
    
    # Tabs initialization code
    $('#tablist a:first').tab 'show'
    $('#tablist a').click (e) ->
        e.preventDefault()
        $(this).tab('show')
    
    $('#gonewchat').click ->
        return if $('#newchat').val() == ""
        id = $('#newchat').val()
        if discussions[id] != undefined
            $('#tablist a[href="#'+id+'"]').tab 'show' 
            return
        discussions[id] = {}
        createNewTab(id)
        $('#tablist a[href="#'+id+'"]').tab 'show' 
        socket.emit 'chatrequest', {source: user.getID(), dest: id, pubkey: user.getRSAPubstring()}
    
    $('#newidentity').click ->
        $('#loadingmodal').modal 'show'
        setTimeout () ->
                newIdentity()
            , 1000
