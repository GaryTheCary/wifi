Meteor._passport = 
    _deviceID: "390043001147343339383037"
    _accessToken: "2eeb0cdc3f4074ee227a372438e6d2c459816e8d"


Meteor._toggleEvent = 
   _setAction: (_deviceID, _accessToken, _formID) ->
     _requestURL = "https://api.particle.io/v1/devices/" + _deviceID + "/led?access_token=" + _accessToken
     _formaction = document.getElementById _formID
     _formaction.action = _requestURL
     console.log "POST URL is:" + _formaction.action

     


                 
        






