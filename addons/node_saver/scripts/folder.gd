@tool
extends VBoxContainer

class _property:
	const GUI_PROPERTY:PackedScene = preload("res://addons/node_saver/scenes/property.tscn")
	static func create(setter:StringName,getter:StringName,title:String)->_property:
			var res:_property = _property.new()
			res.set_gui(GUI_PROPERTY.instantiate())
			res.set_setter(setter)
			res.set_getter(getter)
			res.set_property_name(title)
			return res
	var gui:Control : set=set_gui
	func set_gui(v:Control)->void:gui = v
	func get_gui()->Control:return gui
#	var type:int : set=set_type
#	func set_type(v:int)->void:type = v
	func set_visible(v:bool):gui.call_deferred("set_visible",v)
	func set_active(v:bool):gui.call_deferred("set_active",v)
	func set_property_name(v:String):gui.call_deferred("set_property_name",v)
	func set_setter(v:StringName):gui.call_deferred("set_setter",v)
	func set_getter(v:StringName):gui.call_deferred("set_getter",v)
	func is_active()->bool:return gui.is_active()
	func get_property_name()->String:return gui.get_property_name()
	func get_setter()->StringName:return gui.get_setter()
	func get_getter()->StringName:return gui.get_getter()
	func queue_free()->void:gui.queue_free()
class _method extends _property:
	const GUI_METHOD:PackedScene = preload("res://addons/node_saver/scenes/method.tscn")
	func set_gui_(v:Control)->void:
		gui = v
		gui.connect("do_delete", Callable(self, "queue_free"))
	static func create_(setter:StringName,getter:StringName)->_method:
		var res:_method = _method.new()
		res.set_gui_(GUI_METHOD.instantiate())
		res.set_setter(setter)
		res.set_getter(getter)
		res.set_property_name(String(setter))
		return res

var items:Array[_property] = [] : set=set_items, get=get_items
func get_items()->Array[_property]:return items
func set_items(v:Array[_property])->void:items = v
func del_item(item:_property):items.erase(item)
var properties:VBoxContainer : set=set_properties
func set_properties(v:VBoxContainer)->void:
	if(is_instance_valid(properties)):
		for c in properties.get_children(true):
			c.queue_free()
	properties = v

var title:String : set=set_title
func set_title(v:String = title):
	title = v
	if(fold):fold.set_text("%s (%s)"%[title, items.size()])
var fold:BaseButton : set=set_fold
func set_fold(v:BaseButton):
	fold = v
	fold.connect("pressed", Callable(self, "on_fold"))
	fold.set_button_icon(FOLDED if folded else UNFOLDED)
	set_title()
func on_fold():set_folded(!folded)
const FOLDED:Texture2D	= preload("res://addons/node_saver/icons/GuiTreeArrowDown.svg")
const UNFOLDED:Texture2D= preload("res://addons/node_saver/icons/GuiTreeArrowRight.svg")
var folded:bool=true : set=set_folded
func set_folded(v:bool):
	folded = v
	fold.set_button_icon(FOLDED if folded else UNFOLDED)
	for i in items:
		i.set_visible(folded)

var items_lost:PackedStringArray=[] : set=set_items_lost, get=get_items_lost
func get_items_lost()->PackedStringArray:return items_lost
func set_items_lost(v:PackedStringArray):
	items_lost = v
	lost_update()
var lost:OptionButton : set=set_lost, get=get_lost
func get_lost()->OptionButton:return lost
func set_lost(v:OptionButton = lost):
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
	for itm in items_lost:lost.add_item(itm)
	lost._select_int(0)
func add_lost(title:String):
	items_lost.append(title)
	lost_update()
func del_lost(id:int):
	items_lost.remove_at(id)
	lost_update()
func on_lost_selection(id:int):
	append_property(lost.get_item_text(id), "", "")
	del_lost(id-1)
	lost._select_int(0)

var ready_add:Callable = Callable()
func append_property(title:String, setter:StringName, getter:StringName):
	var item:_property = _property.create(setter, getter, title)
	items.append(item)
	item.set_visible(folded)
	item.get_gui().connect("tree_exiting", Callable(self, "del_item").bind(item))
	add_child(item.get_gui())
	set_title()
func append_method(setter:StringName, getter:StringName)->void:
	var item:_method = _method.create_(setter, getter)
	items.append(item)
	item.set_visible(folded)
	item.get_gui().connect("tree_exiting", Callable(self, "del_item").bind(item))
	item.get_gui().connect("tree_exiting", Callable(self, "set_title"))
	add_child(item.get_gui())
	set_title()

func get_setters()->Array[StringName]:
	var res:Array[StringName] = []
	for i in items:
		if(i.is_active()):res.append(i.get_setter())
	return res
func get_getters()->Array[StringName]:
	var res:Array[StringName] = []
	for i in items:
		if(i.is_active()):res.append(i.get_getter())
	return res

func _ready():
	set_lost($header/lost)
	set_fold($header/fold)
	set_properties($properties)
