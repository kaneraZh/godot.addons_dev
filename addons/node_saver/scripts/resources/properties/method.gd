extends "res://addons/node_saver/scripts/resources/property.gd"

func set_property(_v:String)->void:property = setter
func set_setter(v:StringName)->void:
	setter = v
	property = setter
