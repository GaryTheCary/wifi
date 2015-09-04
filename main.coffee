
Data = new Mongo.Collection "data"
Users = new Mongo.Collection "users"
Backup = new Mongo.Collection "backup"


# Client Side
if Meteor.isClient
  # Prepartion 
  # Subscrube to the users collection
  
  Meteor.subscribe "users"
  Meteor.subscribe "data"
  
  # Routers for the navigation of mutiple pages/content
  Router.route '/', ->
    this.render 'main' 

  # Template Events
  Template.header.events
    'click .leftCol': -> console.log "previous pic"
    'click .rightCol': -> console.log "next pic"  
  
  Template.btnMenu.events
    'click .deviceBtn': ->
      if Meteor._external._check_btn_state("btnDev", Meteor._btnClass._btnTarget) == true
        #Meteor._serial._connect()
        console.log "bluetooth connnect"
      else
        null  
    'click .disconnectBtn': -> 
      if Meteor._external._check_btn_state("btnDis", Meteor._btnClass._btnTarget) == true
        #Meteor._serial._disconnect()
        console.log "bluetooth disconnect" 
      else
        null
    'click .uploadImageBtn': -> console.log "upload image"
    'click .sendImageBtn': -> console.log "send image" 

  Template.btnMenuWifi.events
    'click .uploadBtn': -> console.log "upload image"
    'click .sendBtn': -> console.log "send image" 
  
  Template.imageBody.rendered = ->
    # Set Default image when user get in
    document.getElementById("uploadImg").src = Meteor._defaultImgUrl._default
    readImage = (file) -> 
      reader = new FileReader()
      image = new Image()
      reader.readAsDataURL(file)
      reader.onload = (_file) ->
        image.src = _file.target.result
        #if Session.get('_filetype') != 'gif' 
        image.onload = -> 
          w = @width
          h = @height
          # Console log the exact resolution of the picture see if it is what we want
          if (w == Meteor._standard._square and h == Meteor._standard._square) or (w == Meteor._standard._rect_W and h == Meteor._standard._rect_H) 
            document.getElementById("uploadImg").src = @src

            Meteor._external._classname "btnDev", Meteor._btnClass._btnTarget
            Meteor._external._classname "btnUpl", Meteor._btnClass._btnTarget
            Meteor._external._classname "btnSed", Meteor._btnClass._btnTarget
            Meteor._external._classname "btnDis", Meteor._btnClass._btnTarget  
            Meteor._external._classname "iconDev", Meteor._btnClass._iconDev
            Meteor._external._classname "iconUpl", Meteor._btnClass._iconUpl
            Meteor._external._classname "iconSed", Meteor._btnClass._iconSed
            Meteor._external._classname "iconDis", Meteor._btnClass._iconDis    
          else
            document.getElementById("uploadImg").src = Meteor._defaultImgUrl._alert
            Meteor._external._classname "btnDev", Meteor._btnClass._btnDefault
            Meteor._external._classname "btnUpl", Meteor._btnClass._btnDefault
            Meteor._external._classname "btnSed", Meteor._btnClass._btnDefault
            Meteor._external._classname "btnDis", Meteor._btnClass._btnDefault  
            Meteor._external._classname "iconDev", Meteor._btnClass._iconDevDefault
            Meteor._external._classname "iconUpl", Meteor._btnClass._iconUplDefault
            Meteor._external._classname "iconSed", Meteor._btnClass._iconSedDefault
            Meteor._external._classname "iconDis", Meteor._btnClass._iconDisDefault
        image.onerror = ->
          alert 'invalid file type' + file.type

    # jQuery function to invoke <img> and check the file type see if they are .gif/.jpg/.png
    $('#choose').change (e) -> 
      ext = @value.match(/\.(.+)$/)[1]
      switch ext 
        when "jpg", "png", "gif", "jpeg"
          $('#uploadButton').attr 'disabled', false
          Session.set '_filetype', ext
        else
          alert "This is not an allowed file"
          @value = ''
      F = @files
      if F and F[0]
        for i in F
          readImage i

    $('#wifichoose').change (e) ->
      ext = @value.match(/\.(.+)$/)[1]
      switch ext
        when "jpg", "png", "gif", "jpeg"
          $("uploadBtn").attr 'disabled', false
          Session.set '_filetype', ext
        else
          alert "This is not an allowed file"
          @value = ''
      F = @files
      if F and F[0]
        for i in F
          readImage i  


# Sever side
if Meteor.isServer
  Meteor.startup ->  
    Meteor._Spark._CheckDB Users
    Meteor._Spark._Login Users 
  Meteor.publish "data", -> Data.find {}
  Meteor.publish "users", -> Users.find {}
  Meteor.setInterval ->
    ServerSession.set 'index', (Data.find().count()-1)
  , 5000

  # Reformat the data into binary
  # Set up a indicator to see if there is any new data being added so that we could run a php file
  data_index = Data.find().count()
  data_index_prev = data_index
  Meteor.setInterval ->
    data_index = Data.find().count()
    if data_index != data_index_prev
      console.log "New Doc Appeared"
      data_index_prev = data_index
      dataOBJ = Data.findOne {_id: (data_index-1).toString()}
      in_data = dataOBJ.data
      temp = new Uint8Array(in_data.length)
      counter = 0
      for i in in_data
        temp[counter] = i
        counter++
      Data.update({_id: (data_index-1).toString()},{$set:{data: temp}})  
  , 1000

  Router.route '/data', (->
    req = @request
    res = @response
    res.setHeader 'access-control-allow-origin', '*'
    Meteor.setInterval ->
      _id = ServerSession.get('index').toString()
      _root = Data.findOne {_id: _id}
      if _root?
        res.statusCode = 200
        res.write _root.data
      else
        res.statusCode = 404
        res.end {status: "404", message: "Data not found"}  
    , 5000  
  ), {where:'server'}












