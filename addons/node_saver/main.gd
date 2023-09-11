@tool
extends EditorPlugin

var dock:Container : set=set_dock, get=get_dock
func get_dock()->Container:return dock
func set_dock(v:Container):
	dock = v
	dock.set_editor_selection(get_editor_interface().get_selection())
	add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_UL, dock)

func _enter_tree():
	set_dock(load("res://addons/node_saver/scenes/dock.tscn").instantiate())

func _exit_tree():
	if(get_dock()):
		remove_control_from_docks(dock)
		dock.queue_free()
