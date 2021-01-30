extends Camera

export var smoothedMotion = 20
export var camOffset = 12
export (NodePath) onready var follow = get_node(follow).get_child(0)


func _process(delta):
	transform.origin += (follow.transform.origin + Vector3(0,2,0) + transform.basis.z*camOffset - transform.origin) * smoothedMotion * delta
	#look_at(follow.transform.origin + Vector3(0,7,0), Vector3.UP)
