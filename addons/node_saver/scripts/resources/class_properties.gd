extends Resource

var properties:Array=[] : set=set_properties, get=get_properties
func get_properties()->Array:properties
func set_properties(v:Array)->void:
	properties = v

func get_setters()->Array[StringName]:
	var res:Array[StringName]
	for p in properties:res.append(p.get_setter)
	return gui.get_setter()
func get_getters()->Array[StringName]:
	var res:Array[StringName]
	for p in properties:res.append(p.get_getter)
	return gui.get_getter()

func add_property(name:String, setter:String, getter:String)->void:
	pass
func add_property(setter:String, getter:String)->void:
	pass

func add_object(setter:String, getter:String, behaviour:int)