extends Resource

var type:int : set=set_type, get=get_type
func set_type(v:int)->void:type = v
func get_type()->int:return type

var property:String : set=set_property, get=get_property
func set_property(v:String)->void:property = v
func get_property()->String:return property
var setter:StringName : set=set_setter, get=get_setter
func set_setter(v:StringName)->void:setter = v
func get_setter()->StringName:return setter
var getter:StringName : set=set_getter, get=get_getter
func set_getter(v:StringName)->void:getter = v
func get_getter()->StringName:return getter

const TYPE_STR:PackedStringArray = [
	"null",
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
#enum TYPE {
#	void,
#	bool,
#	int,
#	float,
#	String,
#	Vector2,
#	Vector2i,
#	Rect2,
#	Rect2i,
#	Vector3,
#	Vector3i,
#	Transform2D,
#	Vector4,
#	Vector4i,
#	Plane,
#	Quaternion,
#	AABB,
#	Basis,
#	Transform3D,
#	Projection,
#	Color,
#	StringName,
#	NodePath,
#	RID,
#	Object,
#	Callable,
#	Signal,
#	Dictionary,
#	Array,
#	PackedByteArray,
#	PackedInt32Array,
#	PackedInt64Array,
#	PackedFloat32Array,
#	PackedFloat64Array,
#	PackedStringArray,
#	PackedVector2Array,
#	PackedVector3Array,
#	PackedColorArray
#}

var properties:Array=[] : set=set_properties, get=get_properties
func get_properties()->Array:return properties
func set_properties(v:Array)->void:properties = v
func append_property(property:Resource)->void:properties.append(property)

func get_setters()->Array[StringName]:
	var res:Array[StringName]
	for p in properties:res.append(p.get_setter())
	return res
func get_getters()->Array[StringName]:
	var res:Array[StringName]
	for p in properties:res.append(p.get_getter())
	return res

const PROPERTY:Resource = preload("res://addons/node_saver/scripts/resources/property.gd")
func add_property(type:int, setter:String, getter:String, property_name:String)->void:
	var res:Resource = PROPERTY.new()
	res.set_type(type)
	res.set_setter(setter)
	res.set_getter(getter)
	res.set_property(property_name)
	properties.append(res)
const METHOD:Resource = preload("res://addons/node_saver/scripts/resources/properties/method.gd")
func add_method(type:int, setter:String, getter:String)->void:
	var res:Resource = METHOD.new()
	res.set_type(type)
	res.set_setter(setter)
	res.set_getter(getter)
	properties.append(res)
const OBJECT:Resource = preload("res://addons/node_saver/scripts/resources/properties/object.gd")
func add_object(type:int, setter:String, getter:String, property_name:String)->void:
	var res:Resource = OBJECT.new()
	res.set_type(type)
	res.set_setter(setter)
	res.set_getter(getter)
	res.set_property(property_name)
	properties.append(res)
