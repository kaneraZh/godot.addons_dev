@tool
extends "res://addons/node_saver/scripts/property.gd"

var _behaviour:OptionButton : set=_set_behaviour, get=_get_behaviour
func _set_behaviour(v:OptionButton)->void:
	_behaviour = v
	_behaviour.connect("item_selected", Callable(self, "_on_behaviour_select"))
func _get_behaviour()->OptionButton:return _behaviour
func _on_behaviour_select(index:int):set_behaviour(index)

var behaviour:int=0 : set=set_behaviour, get=get_behaviour
func set_behaviour(v:int)->void:
	behaviour = v
	set_active()
	set_property_name()
func get_behaviour()->int:return behaviour
func set_active(_v:bool = active)->void:
	active = behaviour!=0
	set_modulate(Color("ffffff") if active else Color("ffffff70"))

func set_property_name(v:String = property_name)->void:
	property_name = v
	if(_behaviour):
		const BEHAVIOURS:PackedStringArray = [
			"%s",
			"str(%s)",
			"%s.get_path()"
		]
		for i in BEHAVIOURS.size():
			_behaviour.set_item_text(i, BEHAVIOURS[i]%property_name)

func _ready():
	_set_behaviour($behaviour)
	_set_setter($setter)
	_set_getter($order/getter)
	_set_deleter($order/delete)

func to_resource()->Resource:
	var res:Resource = load("res://addons/node_saver/scripts/resources/properties/object.gd")
	res.set_type(get_type())
	res.set_property(get_property_name())
	res.set_setter(get_setter())
	res.set_getter(get_getter())
	res.set_behaviour(get_behaviour()-1)
	return res
