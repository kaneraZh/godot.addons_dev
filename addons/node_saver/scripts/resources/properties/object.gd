extends "res://addons/node_saver/scripts/resources/property.gd"

func set_type(v:int)->void:
	if(v!=TYPE_OBJECT):push_error("type of object is incorrect")
	type = v

enum BEHAVIOUR {
	TO_STRING,
	GET_PATH
}
var behaviour:int=BEHAVIOUR.GET_PATH : set=set_behaviour, get=get_behaviour
func set_behaviour(v:int):behaviour = clampi(v, BEHAVIOUR.TO_STRING, BEHAVIOUR.GET_PATH)
func get_behaviour()->int:return behaviour

func parse_object(obj:Object)->String:
	match behaviour:
		BEHAVIOUR.TO_STRING:
			return obj._to_string()
		BEHAVIOUR.GET_PATH:
			return obj.call(&"get_path" if (obj is Resource) else &"get_scene_file_path")
	return ""
