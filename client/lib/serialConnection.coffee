# This is the lib of all the functions of bluetooth connection

Meteor._address = 
  _macAddress: "00:06:66:6A:AF:77"
  _char: ""

Meteor._serial =  
  _connect: ->
    Meteor._serial._clear()
    Meteor._serial._display "Attempt to connect. " + "Make sure the serial port is open on the target device." 
    bluetoothSerial.connect Meteor._address._macAddress, Meteor._serial._openPort, Meteor._serial._showError
  _disconnect: -> 
    Meteor._serial._display "Attempt to disconnect" 
    bluetoothSerial.disconnect Meteor._serial._closePort, Meteor._serial._showError
  _openPort: ->
    Meteor._serial._display "Connected to: " + Meteor._address._macAddress
    bluetoothSerial.subscribe '\n', (data) -> 
                                       Meteor._serial._clear() 
                                       Meteor._serial._display data 
  _closePort: ->
    Meteor._serial._display "Disconnected from: " + Meteor._address._macAddress
    bluetoothSerial.unsubscribe ((data)->Meteor._serial._display data), (Meteor._serial._showError) 

  _showError: (error)->
    Meteor._serial._display error

  _display: (message)->
    _display_text = document.getElementById "message"
    _lineBreak = document.createElement "br"
    _label = document.createTextNode message
    _display_text.appendChild _lineBreak
    _display_text.appendChild _label

  _clear: ->
    _display_text = document.getElementById "message"
    _display_text.innerHtml = ""       





