@tool
extends VBoxContainer

##### ABSTRACT #############################

var title:String : set=set_title, get=get_title
func get_title()->String:return title
func set_title(v:String = title)->void:
	title = v
	if(_title):
		_title.set_text(title)

class _folder:
	const GUI:PackedScene = preload("res://addons/node_saver/scenes/folder.tscn")
	static func create(title:String)->_folder:
		var res:_folder = _folder.new()
		res.set_gui(GUI.instantiate())
		res.set_title(title)
		return res
	var gui:Control : set=set_gui, get=get_gui
	func set_gui(v:Control)->void:gui = v
	func get_gui()->Control:return gui
	
	var title:String: set=set_title, get=get_title
	func set_title(v:String = title)->void:
		title = v
		gui.set_title(title)
	func get_title()->String:return title
	
	var items_lost:int = 0
	var items_found:int= 0
	func add_lost(type:int, title:String):
		gui.add_lost(type, title)
		items_lost+= 1
	func add_property(type:int, setter:StringName, getter:StringName, title:String, behaviour:int=0)->void:
		if(setter=="" || getter=="" || title==""):return
		gui.add_item(type, setter, getter, title, behaviour)
		items_found+= 1
	func add_method(type:int, setter:StringName, getter:StringName, behaviour:int=0)->void:
		if(type==-1 || setter=="" || getter==""):return
		gui.add_item(type, setter, getter, "", behaviour)
		items_found+= 1
	
	func get_setters()->Array[StringName]:return gui.get_setters()
	func get_getters()->Array[StringName]:return gui.get_getters()
	func _to_string():return title
	func queue_free()->void:gui.queue_free()
	func get_size()->int:return items_found+items_lost
	func is_empty()->bool:return items_found+items_lost == 0

static func get_node_properties(node:Node)->Array[_folder]:
	var res:Array[_folder] = []
	
	var setters:Array[String] = []
	var getters:Array[String] = []
	const SET:String = "set_"
	const GET:String = "get_"
	const GIS:String = "is_"
	for m in node.get_method_list():
		var nm:String = m["name"]
		if( nm.begins_with(SET) ):	setters.append(nm)
		elif( nm.begins_with(GET) ):getters.append(nm)
		elif( nm.begins_with(GIS) ):getters.append(nm)
	
	var properties:Array = []
	for p in node.get_property_list():
		var property_name
		var usage:int = p.get("usage")
		if(usage & PROPERTY_USAGE_NEVER_DUPLICATE):pass
		elif(usage & PROPERTY_USAGE_STORAGE):
			properties.back().append( p )
		elif(usage==PROPERTY_USAGE_CATEGORY):
			res.append(_folder.create(p.get("name")))
			properties.append([])
	
	const SETTER:String = "set_%s"
	const GETTER:String = "get_%s"
	const GISTER:String = "is_%s"
	for i in res.size():
		var c_folder:_folder = res[i]
		for p in properties[i]:
			var name:String = p.get("name")
			var type:int = p.get("type")
			var st:String = SETTER%name
			var gt:String = GETTER%name
			var gi:String = GISTER%name
			if(setters.has(st) && (getters.has(gt) || getters.has(gi)) ):
				var getter:StringName = gt if (getters.has(gt)) else gi
				c_folder.add_property(type, st, getter, name)
				setters.erase(st)
				getters.erase(getter)
			else:c_folder.add_lost(type, name)
	res.reverse()
	#print('prop size: %s'%properties.size())
	for c in res:
		#print('%2s - %s'%[c.get_size(), c.title])
		if(c.is_empty()):c.queue_free()
	return res

var property_container:Control : set=set_property_container
func set_property_container(v:Control)->void:
	property_container = v
	update_folder()
var hash:int
var folders:Array[_folder]
func set_folders(node:Node)->void:
#	if(is_instance_valid(property_container)):
#		for c in property_container.get_children():c.queue_free()
	var res:Array[_folder] = get_node_properties(node)
	hash = node.get_property_list().hash()
	res.append(_folder.create("Custom Methods"))
	for f in res:
		f.get_gui().connect("tree_exiting", Callable(self, "delete_folder").bind(f))
	folders = res
	set_title( folders.front().get_title() )
	update_folder()
func del_folders()->void:
	folders = []
	update_folder()
func update_folder()->void:
	if(is_instance_valid(property_container)):
		for c in property_container.get_children():c.queue_free()
		for f in folders:property_container.add_child(f.get_gui())
func delete_folder(f:_folder)->void:
	var id:int = folders.find(f)
	if(id==-1):return
	folders[id].queue_free()
	folders.remove_at(id)
func append_folder(f:_folder)->void:
	folders.append(f)
func append_method(type:int, setter:StringName, getter:StringName)->void:
	folders.back().add_method(type, setter, getter)
func queue_free_folders()->void:
	for f in folders:
		f.queue_free()
	call_deferred("set_folders", [])

var editor_selection:EditorSelection : set=set_editor_selection, get=get_editor_selection
func set_editor_selection(v:EditorSelection)->void:
	editor_selection = v
	editor_selection.connect("selection_changed", Callable(self, "on_selection_change"))
	on_selection_change()
func get_editor_selection()->EditorSelection:return editor_selection
func on_selection_change()->void:
	if(editor_selection.get_selected_nodes()):
		set_folders(editor_selection.get_selected_nodes()[0])
	else:
		_title.set_text("")
		del_folders()

var _title:LineEdit : set=_set_title
func _set_title(v:LineEdit)->void:
	_title = v
	set_title()
var load_btn:Button : set=set_load_btn
func get_load_btn()->Button:return load_btn
func set_load_btn(v:Button)->void:
	load_btn = v
	load_btn.connect("pressed", Callable(self, "on_load_btn"))
func on_load_btn()->void:
#	print(node.get_getters())
	pass
var save_btn:Button : set=set_save_btn
func get_save_btn()->Button:return save_btn
func set_save_btn(v:Button)->void:
	save_btn = v
	save_btn.connect("pressed", Callable(self, "on_save_btn"))
func on_save_btn()->void:
#	print(node.get_setters())
	pass

var _type:OptionButton : set=_set_type
func _set_type(v:OptionButton)->void:_type = v
var _setter:LineEdit : set=_set_setter
func _set_setter(v:LineEdit)->void:_setter = v
var _getter:LineEdit : set=_set_getter
func _set_getter(v:LineEdit)->void:_getter = v
var _adder:Button : set=_set_adder
func _get_adder()->Button:return _adder
func _set_adder(v:Button)->void:
	_adder = v
	_adder.connect("pressed", Callable(self, "_on_adder"))
func get_type()->int:return _type.get_selected_id()+1
func get_setter()->String:return _setter.get_text()
func get_getter()->String:return _getter.get_text()
func _on_adder():
	append_method(get_type(), get_setter(), get_getter())

var singleton:Button : set=set_singleton
func get_singleton()->Button:return singleton
func set_singleton(v:Button)->void:
	singleton = v
#	singleton.connect("pressed")

func _ready():
	set_property_container($Panel/container/ScrollContainer/property_container)
	_set_title($title)
	set_load_btn($actions/load)
	set_save_btn($actions/save)
	
	_set_type($extra/orden/type)
	_set_adder($extra/orden/adder)
	_set_setter($extra/setter)
	_set_getter($extra/getter)
	
	set_singleton($singleton)
