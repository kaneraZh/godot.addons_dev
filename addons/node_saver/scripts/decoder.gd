extends Resource
#func lala():
#	bool(false)
#	int(0)
#	float(0)
#	String("")
static func s(v):
	if(v is Vector2):	return "v(%s, %s)"%			[v.x, v.y]	#"v(0, 0)"
	if(v is Vector2i):	return "v(%s, %s)"%			[v.x, v.y]	#"v(0, 0)"
	if(v is Vector3):	return "v(%s, %s, %s)"%		[v.x, v.y, v.z]	#"v(0, 0, 0)"
	if(v is Vector3i):	return "v(%s, %s, %s)"%		[v.x, v.y, v.z]	#"v(0, 0, 0)"
	if(v is Vector4):	return "v(%s, %s, %s, %s)"%	[v.x, v.y, v.z, v.w] #"v(0, 0, 0, 0)"
	if(v is Vector4i):	return "v(%s, %s, %s, %s)"%	[v.x, v.y, v.z, v.w] #"v(0, 0, 0, 0)"
	if(v is Quaternion):return "q(%s, %s, %s, %s)"%	[v.x, v.y, v.z, v.w] #"q(0, 0, 0, 1)"
	if(v is Color):		return "c(%s, %s, %s, %s)"%	[v.r, v.g, v.b, v.a] #"c(0, 0, 0, 1)"
#	^[vcq]\((%s(,\s)?)+\)$
#	for all the basic ones
	
	if(v is Rect2):		return "[P: %s, S: %s]"%	[s(v.position), s(v.size)]	#"[P: v(0, 0), S: v(0, 0)]"
	if(v is Rect2i):	return "[P: %s, S: %s]"%	[s(v.position), s(v.size)]	#"[P: v(0, 0), S: v(0, 0)]"
	if(v is Transform2D):return "[X: %s, Y: %s, O: %s]"%[s(v.x), s(v.y), s(v.origin)]	#"[X: v(1, 0), Y: v(0, 1), O: v(0, 0)]"
	if(v is Plane):		return "[N: %s, D: %s]"%	[s(v.normal), s(v.d)] #"[N: v(0, 0, 0), D: 0]"
	if(v is AABB):		return "[P: %s, S: %s]"%	[s(v.position), s(v.size)] #"[P: v(0, 0, 0), S: v(0, 0, 0)]"
	if(v is Basis):		return "[X: %s, Y: %s, Z: %s]"%[s(v.x), s(v.y), s(v.z)] #"[X: v(1, 0, 0), Y: v(0, 1, 0), Z: v(0, 0, 1)]"
#	if(v is Transform3D):return "[X: %s, Y: %s, Z: %s, O: %s]"%[s(v.origin.x), s(v.origin.y), s(v.origin.z), s(v.origin)] #"[X: (1, 0, 0), Y: (0, 1, 0), Z: (0, 0, 1), O: (0, 0, 0)]"
#	if(v is Projection):return "\n1, 0, 0, 0\n0, 1, 0, 0\n0, 0, 1, 0\n0, 0, 0, 1" #"\n1, 0, 0, 0\n0, 1, 0, 0\n0, 0, 1, 0\n0, 0, 0, 1"
	if(v is Transform3D):return "[B: %s, O: %s]"%[s(v.basis), s(v.origin)] #"[B: [X: v(1, 0, 0), Y: v(0, 1, 0), Z: v(0, 0, 1)], O: v(0, 0, 0)]"
	if(v is Projection):return "[X: %s, Y: %s, Z: %s, W: %s]"%[s(v.x), s(v.y), s(v.z), s(v.w)] #"[X: v(1, 0, 0, 0), Y: v(0, 1, 0, 0), Z: v(0, 0, 1, 0), W: v(0, 0, 0, 1)]"
#	^\[([XYZWPSNDBO]\:\s\%s(\,\s)?)+\]$
#	for all the ones that nest basic ones
	
	if(v is StringName):return "&%s"%v#""
	if(v is NodePath):	return "$%s"%v#""
	if(v is RID):		return "r%s"#"RID(0)"
#	if(v is Object): #"<Object#null>"
#	if(v is Callable): #"null::null"
#	if(v is Signal): #"null::[signal]"
	if(v is Dictionary):		return {}	#{}
	if(v is Array):				return []	#[]
	if(v is PackedByteArray):	return "[]"	#"[]"
	if(v is PackedInt32Array):	return []	#[]
	if(v is PackedInt64Array):	return []	#[]
	if(v is PackedFloat32Array):return []	#[]
	if(v is PackedFloat64Array):return []	#[]
	if(v is PackedStringArray):	return []	#[]
	if(v is PackedVector2Array):return "[]"	#"[]"
	if(v is PackedVector3Array):return "[]"	#"[]"
	if(v is PackedColorArray):	return "[]"	#"[]"

static func d(v):
	if(v is Vector2):	return {'x':v.x, 'y':v.y}
	if(v is Vector2i):	return {'x':v.x, 'y':v.y}
	if(v is Vector3):	return {'x':v.x, 'y':v.y, 'z':v.z}
	if(v is Vector3i):	return {'x':v.x, 'y':v.y, 'z':v.z}
	if(v is Vector4):	return {'x':v.x, 'y':v.y, 'z':v.z, 'w':v.w}
	if(v is Vector4i):	return {'x':v.x, 'y':v.y, 'z':v.z, 'w':v.w}
	if(v is Quaternion):return {'x':v.x, 'y':v.y, 'z':v.z, 'w':v.w}
	if(v is Color):		return {'r':v.x, 'g':v.y, 'b':v.z, 'a':v.w}
	if(v is Rect2):		return {'p':s(v.position), 's':s(v.size)}
	if(v is Rect2i):	return {'p':s(v.position), 's':s(v.size)}
	if(v is Transform2D):return{'x':s(v.x), 'y':s(v.y), 'o':s(v.origin)}
	if(v is Plane):		return {'n':s(v.normal), 'd':s(v.d)}
	if(v is AABB):		return {'p':s(v.position), 's':s(v.size)}
	if(v is Basis):		return {'x':s(v.x), 'y':s(v.y), 'z':s(v.z)}
#	if(v is Transform3D):return "[X: %s, Y: %s, Z: %s, O: %s]"%[s(v.origin.x), s(v.origin.y), s(v.origin.z), s(v.origin)] #"[X: (1, 0, 0), Y: (0, 1, 0), Z: (0, 0, 1), O: (0, 0, 0)]"
#	if(v is Projection):return "\n1, 0, 0, 0\n0, 1, 0, 0\n0, 0, 1, 0\n0, 0, 0, 1" #"\n1, 0, 0, 0\n0, 1, 0, 0\n0, 0, 1, 0\n0, 0, 0, 1"
	if(v is Transform3D):return{'b':s(v.basis), 'o':s(v.origin)}
	if(v is Projection):return {'x':s(v.x), 'y':s(v.y), 'z':s(v.z), 'w':s(v.w)}
	if(v is StringName):return "&%s"%v
	if(v is NodePath):	return "$%s"%v
	if(v is RID):		return "r%s"
#	if(v is Object): #"<Object#null>"
#	if(v is Callable): #"null::null"
#	if(v is Signal): #"null::[signal]"
	if(v is Dictionary):		return {}	#{}
	if(v is Array):				return []	#[]
	if(v is PackedByteArray):	return "[]"	#"[]"
	if(v is PackedInt32Array):	return []	#[]
	if(v is PackedInt64Array):	return []	#[]
	if(v is PackedFloat32Array):return []	#[]
	if(v is PackedFloat64Array):return []	#[]
	if(v is PackedStringArray):	return []	#[]
	if(v is PackedVector2Array):return "[]"	#"[]"
	if(v is PackedVector3Array):return "[]"	#"[]"
	if(v is PackedColorArray):	return "[]"	#"[]"
