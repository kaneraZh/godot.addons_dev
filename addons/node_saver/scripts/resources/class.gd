extends Resource

class group:
	var title:String : set=set_title, get=get_title
	func set_title(v:String)->void:title = v
	func get_title()->String:return title
	var properties:Array[Resource] = []
#const PROPERTIES:Resource = preload("res://addons/node_saver/scripts/resources/class_properties.gd")
#static func get_node_peoperties(node:Node)->Array[PROPERTIES]:
#	var res:Array[PROPERTIES] = []
#
#	var setters:Array[String] = []
#	var getters:Array[String] = []
#	const SET:String = "set_"
#	const GET:String = "get_"
#	const GIS:String = "is_"
#	for m in node.get_method_list():
#		var nm:String = m["name"]
#		if( nm.begins_with(SET) ):	setters.append(nm)
#		elif( nm.begins_with(GET) ):getters.append(nm)
#		elif( nm.begins_with(GIS) ):getters.append(nm)
#
#	var properties:Array = []
#	for p in node.get_property_list():
#		var usage:int = p.get("usage")
#		if(usage & PROPERTY_USAGE_NEVER_DUPLICATE):pass
#		elif(usage & PROPERTY_USAGE_STORAGE):
#			properties.back().append( p )
#		elif(usage==PROPERTY_USAGE_CATEGORY):
#			var folder:Resource = PROPERTIES.new()
#			folder.set_name_of_class(p.get("name"))
#			res.append(folder)
#			properties.append([])
#
#	const SETTER:String = "set_%s"
#	const GETTER:String = "get_%s"
#	const GISTER:String = "is_%s"
#	for i in res.size():
#		var class_properties:Resource = res[i]
#		for p in properties[i]:
#			var name:String = p.get("name")
#			var type:int = p.get("type")
#			var st:String = SETTER%name
#			var gt:String = GETTER%name
#			var gi:String = GISTER%name
#			if(setters.has(st) && (getters.has(gt) || getters.has(gi)) ):
#				var getter:StringName = gt if (getters.has(gt)) else gi
#				match type:
#					TYPE_OBJECT:
#						class_properties.add_object(type, st, getter, name)
#					_:
#						class_properties.add_property(type, st, getter, name)
#				setters.erase(st)
#				getters.erase(getter)
#			else:class_properties.add_lost(name)
#	res.reverse()
##		print('prop size: %s'%properties.size())
#	for c in res:
##			print('%2s - %s'%[c.get_size(), c.title])
#		if(c.is_empty()):c.queue_free()
#	return res

#func set_up_class(node:Node)->void:
#	set_class_properties(get_node_peoperties(node))
#	set_hash(node)

var hash:int : get=get_hash
func set_hash(node:Node)->void:hash = node.get_property_list().hash()
func get_hash()->int:return hash
var title:String : set=set_title, get=get_title
func set_title(v:String)->void:title = v
func get_title()->String:return title
var class_properties:Array[Resource]=[] : set=set_class_properties
func set_class_properties(v:Array[Resource])->void:class_properties = v
func add_class_properties(v:Resource)->void:class_properties.append(v)
func del_class_properties(v:Resource)->void:class_properties.erase(v)
func set_class_titles(title:Array[String])->void:
	class_properties = []
	for t in title:
		var properties:group = group.new()
		properties.set_title(t)
		class_properties.append(properties)
func add_class_title(title:String)->void:
	var res:group = group.new()
	res.set_title(title)
	add_class_properties(res)
func del_class_title(title:String)->void:
	for i in class_properties.size():
		if(class_properties[i].get_name_of_class()==title):
			class_properties.remove_at(i)
			return

var groups:Array
var properties:Array=[] : set=set_properties, get=get_properties
func get_properties()->Array:return properties
func set_properties(v:Array)->void:properties = v
func append_property(property:Resource)->void:properties.append(property)

func get_assert_node()->String:
	return "%s:preload('res://addons/node_saver/generated/resources/%s.gd').save_node(node)\n"%[get_hash(), get_title]
#func get_getters()->Array[StringName]:
#	var res:Array[StringName] = []
#	print("from %s:"%get_title())
#	for f in class_properties:
#		print("\tgetting %s"%f.get_title())
#		res.append_array(f.get_getters())
#	return res
#func get_setters()->Array[StringName]:
#	var res:Array[StringName] = []
#	print("from %s"%get_title())
#	for f in class_properties:
#		print("getting %s"%f.get_title())
#		res.append_array(f.get_setters())
#	return res
func const_setters()->String:
	return "SET_%s:Array = %s"%[
		get_title().to_upper(),
		JSON.stringify(get_setters(), '\t', false)
	]
func const_getters()->String:
	return "GET_%s:Array = %s"%[
		get_title().to_upper(),
		JSON.stringify(get_getters(), '\t', false)
	]

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
