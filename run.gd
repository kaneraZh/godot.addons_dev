@tool
extends EditorScript

const TYPES_STRING:PackedStringArray = [
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
static var TYPES_EMPTY:Array = [
	bool(),
	int(),
	float(),
	String(),
	Vector2(),
	Vector2i(),
	Rect2(),
	Rect2i(),
	Vector3(),
	Vector3i(),
	Transform2D(),
	Vector4(),
	Vector4i(),
	Plane(),
	Quaternion(),
	AABB(),
	Basis(),
	Transform3D(),
	Projection(),
	Color(),
	StringName(),
	NodePath(),
	RID(),
	Object(),
	Callable(),
	Signal(),
	Dictionary(),
	Array(),
	PackedByteArray(),
	PackedInt32Array(),
	PackedInt64Array(),
	PackedFloat32Array(),
	PackedFloat64Array(),
	PackedStringArray(),
	PackedVector2Array(),
	PackedVector3Array(),
	PackedColorArray()
]
func stringed():
	print("-------------%s\n%s"%["bool", JSON.stringify(bool())])
	print("-------------%s\n%s"%["int", JSON.stringify(int())])
	print("-------------%s\n%s"%["float", JSON.stringify(float())])
	print("-------------%s\n%s"%["String", JSON.stringify(String())])
	print("-------------%s\n%s"%["Vector2", JSON.stringify(Vector2())])
	print("-------------%s\n%s"%["Vector2i", JSON.stringify(Vector2i())])
	print("-------------%s\n%s"%["Rect2", JSON.stringify(Rect2())])
	print("-------------%s\n%s"%["Rect2i", JSON.stringify(Rect2i())])
	print("-------------%s\n%s"%["Vector3", JSON.stringify(Vector3())])
	print("-------------%s\n%s"%["Vector3i", JSON.stringify(Vector3i())])
	print("-------------%s\n%s"%["Transform2D", JSON.stringify(Transform2D())])
	print("-------------%s\n%s"%["Vector4", JSON.stringify(Vector4())])
	print("-------------%s\n%s"%["Vector4i", JSON.stringify(Vector4i())])
	print("-------------%s\n%s"%["Plane", JSON.stringify(Plane())])
	print("-------------%s\n%s"%["Quaternion", JSON.stringify(Quaternion())])
	print("-------------%s\n%s"%["AABB", JSON.stringify(AABB())])
	print("-------------%s\n%s"%["Basis", JSON.stringify(Basis())])
	print("-------------%s\n%s"%["Transform3D", JSON.stringify(Transform3D())])
	print("-------------%s\n%s"%["Projection", JSON.stringify(Projection())])
	print("-------------%s\n%s"%["Color", JSON.stringify(Color())])
	print("-------------%s\n%s"%["StringName", JSON.stringify(StringName())])
	print("-------------%s\n%s"%["NodePath", JSON.stringify(NodePath())])
	print("-------------%s\n%s"%["RID", JSON.stringify(RID())])
	print("-------------%s\n%s"%["Object", JSON.stringify(Object())])
	print("-------------%s\n%s"%["Callable", JSON.stringify(Callable())])
	print("-------------%s\n%s"%["Signal", JSON.stringify(Signal())])
	print("-------------%s\n%s"%["Dictionary", JSON.stringify(Dictionary())])
	print("-------------%s\n%s"%["Array", JSON.stringify(Array())])
	print("-------------%s\n%s"%["PackedByteArray", JSON.stringify(PackedByteArray())])
	print("-------------%s\n%s"%["PackedInt32Array", JSON.stringify(PackedInt32Array())])
	print("-------------%s\n%s"%["PackedInt64Array", JSON.stringify(PackedInt64Array())])
	print("-------------%s\n%s"%["PackedFloat32Array", JSON.stringify(PackedFloat32Array())])
	print("-------------%s\n%s"%["PackedFloat64Array", JSON.stringify(PackedFloat64Array())])
	print("-------------%s\n%s"%["PackedStringArray", JSON.stringify(PackedStringArray())])
	print("-------------%s\n%s"%["PackedVector2Array", JSON.stringify(PackedVector2Array())])
	print("-------------%s\n%s"%["PackedVector3Array", JSON.stringify(PackedVector3Array())])
	print("-------------%s\n%s"%["PackedColorArray", JSON.stringify(PackedColorArray())])
func string_parse():
	print("---------bool\n%s"%JSON.parse_string( JSON.stringify(bool())))
	print("---------float\n%s"%JSON.parse_string( JSON.stringify(float())))
	print("---------String\n%s"%JSON.parse_string( JSON.stringify(String())))
	print("---------Dictionary\n%s"%JSON.parse_string( JSON.stringify(Dictionary())))
	print("---------Array\n%s"%JSON.parse_string( JSON.stringify(Array())))
func string_parse_typecast():
	print("---------bool\t:\t%s\n%s"%[bool(JSON.parse_string( JSON.stringify(bool()))) is bool, JSON.parse_string( JSON.stringify(bool()))] )
	print("---------int\t:\t%s\n%s"%[int(JSON.parse_string( JSON.stringify(int()))) is int, JSON.parse_string( JSON.stringify(int()))] )
	print("---------float\t:\t%s\n%s"%[float(JSON.parse_string( JSON.stringify(float()))) is float, JSON.parse_string( JSON.stringify(float()))] )
	print("---------String\t:\t%s\n%s"%[String(JSON.parse_string( JSON.stringify(String()))) is String, JSON.parse_string( JSON.stringify(String()))] )
	print("---------StringName\t:\t%s\n%s"%[StringName(JSON.parse_string( JSON.stringify(StringName()))) is StringName, JSON.parse_string( JSON.stringify(StringName()))] )
	print("---------NodePath\t:\t%s\n%s"%[NodePath(JSON.parse_string( JSON.stringify(NodePath()))) is NodePath, JSON.parse_string( JSON.stringify(NodePath()))] )
	print("---------Dictionary\t:\t%s\n%s"%[Dictionary(JSON.parse_string( JSON.stringify(Dictionary()))) is Dictionary, JSON.parse_string( JSON.stringify(Dictionary()))] )
	print("---------Array\t:\t%s\n%s"%[Array(JSON.parse_string( JSON.stringify(Array()))) is Array, JSON.parse_string( JSON.stringify(Array()))] )
	print("---------PackedInt32Array\t:\t%s\n%s"%[PackedInt32Array(JSON.parse_string( JSON.stringify(PackedInt32Array()))) is PackedInt32Array, JSON.parse_string( JSON.stringify(PackedInt32Array()))] )
	print("---------PackedInt64Array\t:\t%s\n%s"%[PackedInt64Array(JSON.parse_string( JSON.stringify(PackedInt64Array()))) is PackedInt64Array, JSON.parse_string( JSON.stringify(PackedInt64Array()))] )
	print("---------PackedFloat32Array\t:\t%s\n%s"%[PackedFloat32Array(JSON.parse_string( JSON.stringify(PackedFloat32Array()))) is PackedFloat32Array, JSON.parse_string( JSON.stringify(PackedFloat32Array()))] )
	print("---------PackedFloat64Array\t:\t%s\n%s"%[PackedFloat64Array(JSON.parse_string( JSON.stringify(PackedFloat64Array()))) is PackedFloat64Array, JSON.parse_string( JSON.stringify(PackedFloat64Array()))] )
	print("---------PackedStringArray\t:\t%s\n%s"%[PackedStringArray(JSON.parse_string( JSON.stringify(PackedStringArray()))) is PackedStringArray, JSON.parse_string( JSON.stringify(PackedStringArray()))] )

func _run():
	const r:Resource = preload("res://addons/node_saver/scripts/resources/class_properties.gd")
	var res:Resource = r.new()
	res.set_name_of_class("lala")
	print(res.get_name_of_class())
	res.set_name_of_class("lolo")
	print(res.get_name_of_class())
	
	
	
#	var regex:RegEx = RegEx.create_from_string("\"(\\d)(\\d)(\\d)\"")
#	create_from_string("\"(?:\\\\.|[^\"])*\"")
#	compile("/(\d)(\d)(\d)")
#	RegEx.create_from_string("(\d)(\d)(\d)")
	
#	var res:Array[RegExMatch] = regex.search_all("123abc")
#	for m in res:
#		print(m)#.strings)
	
#	var res:RegExMatch = regex.search("123abc")
#	print(res)
	
#	print(regex.compile("123abc"))
#	print(regex)
#	var subject := "abc"
#	var pattern := "."
#	var callback := func(text:String) -> String: return text + "&"
#
#	var regex := RegEx.new()
#	regex.compile(pattern)
#
#	var regex_matches := regex.search_all(subject)
#	var offset := 0
#	for regex_match in regex_matches:
#		var start := regex_match.get_start()
#		var end := regex_match.get_end()
#		var length := end - start
#		var text := subject.substr(start + offset, length)
##		var replacement := str(callback.call(text))
#		var replacement := "&%s"%text
#		subject = (
#			subject.substr(0, start + offset)
#			+ replacement
#			+ subject.substr(end + offset)
#		)
#		offset += replacement.length() - text.length()
#	prints(subject)
