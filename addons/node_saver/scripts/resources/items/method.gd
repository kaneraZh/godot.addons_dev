extends "res://addons/node_saver/scripts/resources/item.gd"

func set_name(v:String)->void:
	name = str(setter)
func set_setter(v:StringName)->void:
	setter = v
	name = str(setter)
