Meteor._Spark =
    _CheckDB: (_db)->
        _CheckDB = _db.findOne {email: "xz14ld@student.ocadu.ca"}
        if _CheckDB? then _CheckDB 
        else _CheckDB = null 
    
    _Login: (_db)->
        if Meteor._Spark._CheckDB?
            do ->
                console.log "Device Token is:" + Meteor._Spark._CheckDB(_db).accessToken
                Spark.on 'login', -> Spark.getEventStream false, 'mine', (data)-> console.log "Event: " + JSON.stringify data
                Spark.login {accessToken: Meteor._Spark._CheckDB(_db).accessToken}
                console.log "Login Successfull" 

    _DeviceList: ->
        _devicePr = Spark.listDevices()
        _devicesPr.then ((_devices)->console.log 'Devices: ', _devices), ((_err)->console.log 'Lists devices call failed: ', _err)
        