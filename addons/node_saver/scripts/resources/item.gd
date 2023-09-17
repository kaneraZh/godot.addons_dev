extends Resource

var type:int : set=set_type, get=get_type
func set_type(v:int)->void:type = v
func get_type()->int:return type


var name:String : set=set_name, get=get_name
func set_name(v:String)->void:name = v
func get_name()->String:return name
var setter:StringName : set=set_setter, get=get_setter
func set_setter(v:StringName)->void:setter = v
func get_setter()->StringName:return setter
var getter:StringName : set=set_getter, get=get_getter
func set_getter(v:StringName)->void:getter = v
func get_getter()->StringName:return getter

const TYPE_STR:TypeStringArray = [
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
enum TYPE {
	bool,
	int,
	float,
	String,
	Vector2,
	Vector2i,
	Rect2,
	Rect2i,
	Vector3,
	Vector3i,
	Transform2D,
	Vector4,
	Vector4i,
	Plane,
	Quaternion,
	AABB,
	Basis,
	Transform3D,
	Projection,
	Color,
	StringName,
	NodePath,
	RID,
	Object,
	Callable,
	Signal,
	Dictionary,
	Array,
	PackedByteArray,
	PackedInt32Array,
	PackedInt64Array,
	PackedFloat32Array,
	PackedFloat64Array,
	PackedStringArray,
	PackedVector2Array,
	PackedVector3Array,
	PackedColorArray
}

func get_display_name()->String:
	pass
