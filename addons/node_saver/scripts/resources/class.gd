extends Resource

static func get_node_peoperties(node:Node)->Array[_folder]:
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
	call_de
