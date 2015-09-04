# Thsi is the External functions that main.coffee might be needed eventually

Meteor._external = 
  _pixelData: (_canvas, _ctx, _pixelDataSheet, _outputByteBuffer, _db, _ext) ->
    _imagedata = _ctx.getImageData 0, 0, _canvas.width, _canvas.height
    _data = _imagedata.data
    _index = 0
    _sub_index = 0
    for i in _data
      if _index < (_data.length - 3)
        _pixelDataSheet[_sub_index] = [_data[_index], _data[_index+1], _data[_index+2]]
        _index += 4
        _sub_index += 1
    Meteor._external._stringDeconstruction _pixelDataSheet, _outputByteBuffer, _db, _ext
          

  _classname: (_id, _class) ->
    _obj = document.getElementById _id
    if _obj?
      document.getElementById(_id).className = _class

  _c_drawImg: (canvas_object, _url, _db, _ext) ->
    canvas_ctx = canvas_object.getContext "2d"
    _img = new Image()
    _img.onload = ->
      canvas_ctx.drawImage _img, 0, 0, _img.width, _img.height, 0, 0, 16, 16
      Meteor._external._pixelData canvas_object, canvas_ctx, Meteor._stlAttr.pixelDataSheet, Meteor._stlAttr.outputByteBuffer, _db, _ext
    _img.src = _url       


  _c_resize: (canvas_object, _url) ->
    canvas_ctx = canvas_object.getContext "2d"
    $(window).resize ->
      new_width = $(canvas_object).parent().width()
      new_height = new_width
      canvas_object.width = new_width
      canvas_object.height = new_height
      Meteor._external._c_drawImg canvas_object, _url

  _c_canvas: (c_W, c_H, _url, _db, _ext) ->
    console.log "started"
    canvas = document.createElement 'canvas'
    canvas.id = "dynamicCanvas"
    canvas.width = c_W
    canvas.height = c_H
    document.getElementById("imageCanvasContainer").appendChild canvas
    console.log "over! now try the console"
    #Meteor._external._c_resize canvas, _url
    Meteor._external._c_drawImg canvas, _url, _db, _ext

  _check_btn_state: (_current, _target)->
    _btn_state_name = document.getElementById(_current).className
    if _btn_state_name == _target 
      _check_btn_state = true
    else
      _check_btn_state = false

  _stringDeconstruction: (_pixelDataSheet, _outputByteBuffer, _db, _ext)->
    _index = 0
    _date = new Date()

    for i in _pixelDataSheet
      _outputByteBuffer[_index] = (i[0]&255 | (i[1]&255)>>3 | (i[2]&255)>>6)
      _index++
    if _outputByteBuffer? then Meteor._external._writeJSON _outputByteBuffer, _db, _date, _ext
    else console.log "Sorry the binary data is no found."   
  
  _writeJSON: (_dataArea ,_db, _date, _ext) ->
      if _dataArea?
        _db.insert {data: _dataArea, _id: _db.find().count().toString(), format: _ext}
  

             
         





   






