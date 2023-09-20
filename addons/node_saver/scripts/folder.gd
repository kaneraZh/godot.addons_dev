@tool
extends VBoxContainer

######### ABSTRACT ####################
var title:String : set=set_title, get=get_title
func get_title()->String:return title
func set_title(v:String = title)->void:
	title = v
	if(fold):fold.set_text("%s (%s)"%[title, items_found.size()])
class _item:
	var property:String : set=set_property, get=get_property
	func set_property(v:String)->void:property = v
	func get_property()->String:return property
	var type:int : set=set_type, get=get_type
	func set_type(v:int)->void:type = v
	func get_type()->int:return type
	var setter:StringName : set=set_setter, get=get_setter
	func set_setter(v:StringName)->void:setter = v
	func get_setter()->StringName:return setter
	var getter:StringName : set=set_getter, get=get_getter
	func set_getter(v:StringName)->void:getter = v
	func get_getter()->StringName:return getter
	var behaviour:int : set=set_behaviour, get=get_behaviour
	func set_behaviour(v:int)->void:behaviour = v
	func get_behaviour()->int:return behaviour
	var deletable:bool : set=set_deletable, get=is_deletable
	func set_deletable(v:bool)->void:deletable = v
	func is_deletable()->bool:return deletable
	static func create(type:int, setter:StringName, getter:StringName, property:String="",  behaviour:int=0, deletable:bool=false)->_item:
		var res:_item = _item.new()
		res.set_property(property)
		res.set_type(type)
		res.set_setter(setter)
		res.set_getter(getter)
		res.set_behaviour(behaviour)
		res.set_deletable(deletable)
		return res
var items_found:Array[_item]=[] : set=_set_items_found, get=_get_items_found
func _get_items_found()->Array[_item]:return items_found
func _set_items_found(v:Array[_item]):
	items_found = v
	found_update()
var items_lost:Array[_item]=[] : set=_set_items_lost, get=_get_items_lost
func _get_items_lost()->Array[_item]:return items_lost
func _set_items_lost(v:Array[_item]):
	items_lost = v
	lost_update()

func del_item(id:int)->void:
	items_found.remove_at(id)
	found_update()
func _lost_to_found(id:int)->void:
	items_found.append(items_lost[id])
	items_lost.remove_at(id)
	lost_update()
	found_update()

func add_item(type:int, setter:StringName, getter:StringName, property:String="", behaviour:int=0)->void:
	items_found.append(
		_item.create(
			type,
			setter,
			getter,
			setter if property.is_empty() else property,
			behaviour,
			property.is_empty()
		)
	)
	found_update()
func add_lost(type:int, property:String)->void:
	items_lost.append(_item.create(type, "", "", property, 0))
	lost_update()

######### INTERFACE ###################

# title
var fold:BaseButton : set=_set_fold
func _set_fold(v:BaseButton)->void:
	fold = v
	fold.connect("pressed", Callable(self, "on_fold"))
	fold.set_button_icon(FOLDED if folded else UNFOLDED)
	set_title()
func on_fold()->void:set_folded(!folded)
const FOLDED:Texture2D = preload("res://addons/node_saver/icons/GuiTreeArrowDown.svg")
const UNFOLDED:Texture2D = preload("res://addons/node_saver/icons/GuiTreeArrowRight.svg")
var folded:bool=true : set=set_folded, get=is_folded
func set_folded(v:bool)->void:
	folded = v
	fold.set_button_icon(FOLDED if folded else UNFOLDED)
	properties.set_visible(folded)
func is_folded()->bool:return folded

# items
class _property:
	const PROPERTY:PackedScene = preload("res://addons/node_saver/scenes/property.tscn")
	const OBJECT:PackedScene = preload("res://addons/node_saver/scenes/object.tscn")
	static func create(item:_item)->_property:
		var res:_property = _property.new()
#		print(item.get_type())
		match item.get_type():
#			TYPE_NIL:
#				push_error("nil tipe")
			TYPE_OBJECT:
				res.set_gui(OBJECT.instantiate())
				res.set_behaviour(item.get_behaviour())
			_:
				res.set_gui(PROPERTY.instantiate())
				res.set_active(bool(item.get_behaviour()))
		res.set_type(item.get_type())
		res.set_setter(item.get_setter())
		res.set_getter(item.get_getter())
		res.set_property_name(item.get_property())
		res.set_deletable(item.is_deletable())
		return res
	signal delete
#	signal changed_behaviour
	var gui:Control : set=set_gui
	func set_gui(v:Control)->void:
		gui = v
		v.connect("tree_exiting", Callable(self, "emit_signal").bind("delete"))
#		v.connect("changed_behaviour", Callable(self, "emit_signal").bind("changed_behaviour"))
	func get_gui()->Control:return gui
	func set_type(v:int)->void:		gui.call_deferred("set_type",v)
	func set_visible(v:bool)->void:	gui.call_deferred("set_visible",v)
	func set_active(v:bool)->void:	gui.call_deferred("set_active",v)
	func set_behaviour(v:int)->void:gui.call_deferred("set_behaviour",v)
	func set_property_name(v:String)->void:	gui.call_deferred("set_property_name",v)
	func set_setter(v:StringName)->void:	gui.call_deferred("set_setter",v)
	func set_getter(v:StringName)->void:	gui.call_deferred("set_getter",v)
	func set_deletable(v:bool)->void:		gui.call_deferred("set_deletable",v)
	func queue_free()->void:gui.queue_free()
	func to_resource()->Array[Resource]:return gui.to_resource()

var properties:VBoxContainer : set=set_properties
func set_properties(v:VBoxContainer = properties)->void:
	properties = v
	found_update()
func found_update()->void:
	if(is_instance_valid(properties)):
		set_title()
		for c in properties.get_children(true):
			c.queue_free()
		#var res:Array[_property] = []
		var iteration:int = 0
		for i in items_found:
			var p:_property = _property.create(i)
			#res.append(p)
			properties.add_child(p.get_gui())
			p.connect("delete", Callable(self, "del_item").bind(iteration))
			iteration+=1

var lost:OptionButton : set=_set_lost, get=_get_lost
func _get_lost()->OptionButton:return lost
func _set_lost(v:OptionButton = lost):
	if(v==null):return
	lost = v
	lost.connect("item_selected", Callable(self, "on_lost_selection"))
	lost_update()
const LOST_HEADER_ICON:CompressedTexture2D = preload('res://addons/node_saver/icons/StatusWarning.svg')
const LOST_HEADER_MESSAGE:String = "  setter/getter not found"
func lost_update():
	if(lost==null):return
	lost.set_visible(!items_lost.is_empty())
	lost.clear()
	lost.add_separator(LOST_HEADER_MESSAGE)
	lost.set_item_icon(0, LOST_HEADER_ICON)
	set_title()
	for i in items_lost:
		lost.add_item(i.get_property())
	lost._select_int(0)
func on_lost_selection(id:int):
	lost._select_int(0)
	_lost_to_found(id-1)

func get_setters()->Array[StringName]:
	var res:Array[StringName] = []
	for i in items_found:
		if(i.is_active()):res.append(i.get_setter())
	return res
func get_getters()->Array[StringName]:
	var res:Array[StringName] = []
	for i in items_found:
		if(i.is_active()):res.append(i.get_getter())
	return res

func _ready():
	_set_lost($header/lost)
	_set_fold($header/fold)
	set_properties($properties)
func to_resource()->Array[Resource]:
	var res:Array[Resource] = []
	for i in items_found: 
		if(i.is_active()):
			res.append(i.to_resource())
	return res
