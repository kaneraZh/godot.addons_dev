@tool
extends Control


const TYPE_STR:PackedStringArray = [
	"bool",
	"int",
	"float",
	"String",
	"Vector2",
	"Vector2i",
	"Rect2",
	"Rect2i",
	"Vector3",
	"Vector3i",
	"Transform2D",
	"Vector4",
	"Vector4i",
	"Plane",
	"Quaternion",
	"AABB",
	"Basis",
	"Transform3D",
	"Projection",
	"Color",
	"StringName",
	"NodePath",
	"RID",
	"Object",
	"Callable",
	"Signal",
	"Dictionary",
	"Array",
	"PackedByteArray",
	"PackedInt32Array",
	"PackedInt64Array",
	"PackedFloat32Array",
	"PackedFloat64Array",
	"PackedStringArray",
	"PackedVector2Array",
	"PackedVector3Array",
	"PackedColorArray"
]
var type:int : set=set_type, get=get_type
func set_type(v:int):
	type = v
	if(_active):
		_active.set_button_icon(load("res://addons/node_saver/icons/types/%s.svg"%TYPE_STR[type-1]))
func get_type()->int:return type
signal changed_behaviour
var active:bool : set=set_active, get=is_active
func set_active(v:bool = active)->void:
	active = v
	set_modulate(Color("ffffff") if active else Color("ffffff70"))
	emit_signal("changed_behaviour", active)
	if(_active):_active.set_pressed(v)
func is_active()->bool:return active
var property_name:String : set=set_property_name, get=get_property_name
func set_property_name(v:String = property_name)->void:
	property_name = v
	if(_active):_active.set_text(v)
func get_property_name()->String:return property_name
var setter:String : set=set_setter, get=get_setter
func set_setter(v:String = setter)->void:
	setter = v
	if(_setter):_setter.set_text(v)
func get_setter()->String:return setter
var getter:String : set=set_getter, get=get_getter
func set_getter(v:String = getter)->void:
	getter = v
	if(_getter):_getter.set_text(v)
func get_getter()->String:return getter


var _active:CheckBox : set=_set_active, get=_get_active
func _get_active()->CheckBox:return _active
func _set_active(a:CheckBox)->void:
	_active = a
	_active.connect("toggled", Callable(self, "set_active"))
	set_active()

var _setter:LineEdit : set=_set_setter, get=_get_setter
func _get_setter()->LineEdit:return _setter
func _set_setter(s:LineEdit)->void:
	_setter = s
	set_setter()

var _getter:LineEdit : set=_set_getter, get=_get_getter
func _get_getter()->LineEdit:return _getter
func _set_getter(g:LineEdit)->void:
	_getter = g
	set_getter()

var _deleter:Button : set=_set_deleter, get=_get_deleter
func _get_deleter()->Button:return _deleter
func _set_deleter(d:Button):
	_deleter = d
	_deleter.connect("pressed", Callable(self, "queue_free"))
func set_deletable(v:bool)->void:_deleter.set_visible(v)

func _ready():
	_set_active($active)
	_set_setter($setter)
	_set_getter($order/getter)
	_set_deleter($order/delete)

func to_resource()->Resource:
	var res:Resource = load("res://addons/node_saver/scenes/property.tscn")
	res.set_type(get_type())
	res.set_property(get_property_name())
	res.set_setter(get_setter())
	res.set_getter(get_getter())
	return res
