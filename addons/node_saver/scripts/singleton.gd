extends Node

const CLASSES:Array = [%s]


func save()->void:
	for n in get_tree().get_nodes_in_group("save_me"):
		pass
