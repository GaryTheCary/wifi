Meteor._file = 
	_File: (_id, _db, _function)->
		_textArea = document.getElementById(_id).innerHTML

	_CheckData: (_db, _frequency, _function) ->
		Meteor.setInterval ->
		    _count_buffer = 0
		    _count = _db.find().count()
		    if _count != _count_buffer
		      # Send Data via socket to another server
		      _function
		      console.log "now execute function: " + _function
		      _count_buffer = _count
		    else null 
		  , _frequency

	

		




