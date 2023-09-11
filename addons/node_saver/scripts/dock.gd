@tool
extends VBoxContainer

class _folder:
	static func create(gui:Control, title:String)->_folder:
		var res:_folder = _folder.new()
		res.set_gui(gui)
		res.set_title(title)
		return res
	var gui:Control	: set=set_gui, get=get_gui
	func set_gui(v:Control)->void:gui = v
	func get_gui()->Control:return gui
	var items_lost:int = 0
	var items_found:int= 0
	func add_lost(title:String):
		gui.add_lost(title)
		items_lost+= 1
	var title:String: set=set_title, get=get_title
	func set_title(v:String = title)->void:
		title = v
		gui.set_title(title)
	func get_title()->String:return title
	func append_property(title:String,setter:StringName,getter:StringName)->void:
		if(title=="" || setter=="" || getter==""):return
		gui.append_property(title,setter,getter)
		items_found+= 1
	func append_method(setter:StringName,getter:StringName)->void:
		if(setter=="" || getter==""):return
		gui.append_method(setter,getter)
		items_found+= 1
	func get_setters()->Array[StringName]:return gui.get_setters()
	func get_getters()->Array[StringName]:return gui.get_getters()
	func _to_string():return title
	func queue_free()->void:gui.queue_free()
	func get_size()->int:return items_found+items_lost
	func is_empty()->bool:return items_found+items_lost == 0
class _node:
	const FOLDER:PackedScene = preload("res://addons/node_saver/scenes/folder.tscn")
	static func get_node_folders(node:Node)->Array[_folder]:
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
				properties.back().append( p.get("name") )
			elif(usage==PROPERTY_USAGE_CATEGORY):
				res.append(_folder.create(FOLDER.instantiate(), p.get("name")))
				properties.append([])
		
		const SETTER:String = "set_%s"
		const GETTER:String = "get_%s"
		const GISTER:String = "is_%s"
		for i in res.size():
			var c_folder:_folder = res[i]
			for p in properties[i]:
				var st:String = SETTER%p
				var gt:String = GETTER%p
				var gi:String = GISTER%p
				if(setters.has(st)):
					if(getters.has(gt)):
						c_folder.append_property(p, st, gt)
						setters.erase(st)
						getters.erase(gt)
					elif(getters.has(gi)):
						c_folder.append_property(p, st, gi)
						setters.erase(st)
						getters.erase(gi)
					else:c_folder.add_lost(p)
				else:c_folder.add_lost(p)
		res.reverse()
#		print('prop size: %s'%properties.size())
		for c in res:
#			print('%2s - %s'%[c.get_size(), c.title])
			if(c.is_empty()):c.queue_free()
		return res
	static func create(gui:Control, title:String, node:Node)->_node:
		var res:_node = _node.new()
		res.gui = gui
		res.id = node.get_index()
#		res.title = 
		res.set_folders(get_node_folders(node))
		return res
	var gui:Control
	var id:int
	var title:StringName
	var folders:Array[_folder] : set=set_folders
	func set_folders(v:Array[_folder])->void:
		folders = v
		v.append(_folder.create(FOLDER.instantiate(), "Custom Methods"))
		for f in v:
			f.get_gui().connect("tree_exiting", Callable(self, "delete_folder").bind(f))
			gui.add_child(f.get_gui())
		title = folders.front().get_title()
	func delete_folder(f:_folder):
		var id:int = folders.find(f)
		folders[id].queue_free()
		folders.remove_at(id)
	func append_folder(f:_folder):
#		f.get_gui().connect("tree_exiting", Callable(self, "delete_folder").bind(f))
		folders.append(f)
	func append_method(setter:StringName, getter:StringName)->void:
		folders.back().append_method(setter, getter)
	func get_ifs()->String:return "%sif(node is %s): save.save_node(node)\n"%[title, title]
	func get_getters()->Array[StringName]:
		var res:Array[StringName] = []
		print("from %s, containing %s"%[title, folders])
		for f in folders:
			print("getting %s"%f.get_title())
			res.append_array(f.get_getters())
		return res
	func get_setters()->Array[StringName]:
		var res:Array[StringName] = []
		print("from %s, containing %s"%[title, folders])
		for f in folders:
			print("getting %s"%f.get_title())
			res.append_array(f.get_setters())
		return res
	func const_setters()->String:
		return "SET_%s:Array = %s"%[
			title.to_upper(),
			JSON.stringify(get_setters(), '\t', false)
		]
	func const_getters()->String:
		return "GET_%s:Array = %s"%[
			title.to_upper(),
			JSON.stringify(get_getters(), '\t', false)
		]
	func queue_free_folders()->void:
		for f in folders:
			f.queue_free()
		call_deferred("set_folders", [])

var node:_node
func make_node(nd:Node)->void:
	if(is_instance_valid(node)):node.queue_free_folders()
	node = _node.create($Panel/container/ScrollContainer/property_container, "test", nd)
	if(is_instance_valid(title)):title.set_text(node.title)
func append_method(setter:StringName, getter:StringName):
	node.append_method(setter, getter)

var editor_selection:EditorSelection : set=set_editor_selection, get=get_editor_selection
func set_editor_selection(v:EditorSelection)->void:
	editor_selection = v
	editor_selection.connect("selection_changed", Callable(self, "on_selection_change"))
	on_selection_change()
func get_editor_selection()->EditorSelection:return editor_selection
func on_selection_change()->void:
	if(editor_selection.get_selected_nodes()):
		make_node(editor_selection.get_selected_nodes()[0])
	elif(is_instance_valid(node)):
		title.set_text("")
		node.queue_free_folders()
		node = null

var title:LineEdit	 : set=set_title
func get_title()->String:return title.get_text()
func set_title(v:LineEdit)->void:title = v
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



var setter:LineEdit	 : set=set_setter
func get_setter()->String:return setter.get_text()
func set_setter(v:LineEdit)->void:setter = v
var getter:LineEdit	 : set=set_getter
func get_getter()->String:return getter.get_text()
func set_getter(v:LineEdit)->void:getter = v
var adder:Button	 : set=set_adder
func get_adder()->Button:return adder
func set_adder(v:Button)->void:
	adder = v
	adder.connect("pressed", Callable(self, "on_adder"))
func on_adder():
	append_method(get_setter(), get_getter())

var singleton:Button : set=set_singleton
func get_singleton()->Button:return singleton
func set_singleton(v:Button)->void:
	singleton = v
#	singleton.connect("pressed")

func _ready():
	set_title($title)
	set_load_btn($actions/load)
	set_save_btn($actions/save)
	
	set_setter($extra/setter)
	set_getter($extra/getter)
	set_adder($extra/adder)
	
	set_singleton($singleton)
