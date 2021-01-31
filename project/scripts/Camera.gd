extends Spatial

export var smoothedMotion = 5
export var camOffset = 9
export var height = 2
var offsetFr = camOffset
export var mouseSensitivity = 0.1
export (NodePath) onready var follow = get_node(follow).get_child(0)
onready var cam = $SpringArm/Camera
onready var ray = $RayCast

var smoothRot = Vector2()

var yaw := 0.0
var pitch := 0.0

func _ready():
	$SpringArm.spring_length = camOffset

func _process(delta):
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var pos = follow.global_transform.origin + Vector3(0,height,0)
	var own = global_transform.origin
	global_transform.origin += (pos - own) * smoothedMotion * delta


func _unhandled_input(event):
	if event is InputEventMouseMotion:
			var mouseVec : Vector2 = event.get_relative()
			
			yaw = yaw  - mouseVec.x * mouseSensitivity
			pitch = clamp((pitch - mouseVec.y * mouseSensitivity),-85,-5)
			
			smoothRot = lerp(smoothRot,Vector2(yaw,pitch),1.2)
			yaw = smoothRot.x
			pitch = smoothRot.y
			
			self.set_rotation(Vector3(deg2rad(pitch), deg2rad(yaw), 0.0))


