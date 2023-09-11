@tool
extends Control

var _active:CheckBox : set=_set_active
func _set_active(a:CheckBox)->void:
	_active = a
	set_active()

var active:bool : set=set_active, get=is_active
func set_active(v:bool = active)->void:
	active = v
	if(_active):_active.set_pressed(v)
func is_active()->bool:return _active.is_pressed()

var property_name:String : set=set_property_name, get=get_property_name
func set_property_name(v:String = property_name)->void:
	property_name = v
	if(_active):_active.set_text(v)
func get_property_name()->String:return _active.get_text()

var _setter:LineEdit : set=_set_setter
func _set_setter(s:LineEdit)->void:
	_setter = s
	set_setter()

var setter:String : set=set_setter, get=get_setter
func set_setter(v:String = setter)->void:
	setter = v
	if(_setter):_setter.set_text(v)
func get_setter()->String:return _setter.get_text()

var _getter:LineEdit : set=_set_getter
func _set_getter(g:LineEdit)->void:
	_getter = g
	set_getter()

var getter:String : set=set_getter, get=get_getter
func set_getter(v:String = getter)->void:
	getter = v
	if(_getter):_getter.set_text(v)
func get_getter()->String:return _getter.get_text()

func _ready():
	_set_active($active)
	_set_setter($setter)
	_set_getter($getter)
