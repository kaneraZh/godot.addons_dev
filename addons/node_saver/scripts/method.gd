@tool
extends "res://addons/node_saver/scripts/property.gd"

signal do_delete
var delete:Button : set=_set_delete
func _set_delete(d:Button)->void:
	delete = d
	delete.connect("pressed", Callable(self, "emit_signal").bind("do_delete"))
func set_delete(d:bool)->void:delete.set_pressed(d)
func get_delete()->bool:return delete.is_pressed()

func _ready():
	_set_active($active)
	_set_setter($setter)
	_set_getter($order/getter)
	_set_delete($order/delete)
