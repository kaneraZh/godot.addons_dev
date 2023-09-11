extends Resource

var _data:Dictionary : get=get_data
func get_data()->Dictionary:return _data
func _to_string()->String:return JSON.stringify(_data, '\t', false)

func assert_data(data:Dictionary, keys:Array[StringName])->bool:
	var asserted:bool = true
	for k in data:
		if(!keys.find(k)):
			push_error("<%s> was not found in data submitted"%k)
			asserted = false
	return asserted

func _save_node(node:Node, getters:Array[StringName], keys:Array[StringName]):
	_data = {}
	for i in getters.size():
		var data = node.call(getters[i])
		if(data is Resource):data = data.get_path()
		elif(data is Node):data = data.get_scene_file_path()
		
		_data[keys[i]] = node.call(getters[i])

func _load_node(node:Node, setters:Array[StringName]):
	for setter in setters:
		node.call(setter, _data[setter])
