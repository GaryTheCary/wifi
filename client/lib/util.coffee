# Here is all the global function that main.coffee will needed run on the client side

Meteor._stlAttr =
  pixelDataSheet: new Array()
  device_btn_index: 0
  outputByteBuffer: new Uint8Array(256) 

Meteor._deviceState = 
  _clear: 0
  _disconnected: 1
  _connected: 2
  _offset: 1
  _overflow: 3

Meteor._standard = 
  _square: 16
  _rect_W: 32
  _rect_H: 8

Meteor._ratio = 
  _square_L: 1
  _rect_W2H: 4       

Meteor._defaultImgUrl = 
  _default: "default.png"
  _alert: "alert.png"	

Meteor._btnClass = 
  _btnTarget: "circular pink ui icon button"
  _btnDefault: "circular ui icon button" 
  _iconDev: "inverted large compress icon"
  _iconUpl: "inverted large cloud upload icon"
  _iconSed: "inverted large send icon"
  _iconDis: "inverted large expand icon"
  _iconDevDefault: "large compress icon"
  _iconUplDefault: "large cloud upload icon"
  _iconSedDefault: "large send icon"
  _iconDisDefault: "large expand icon"

  	
         