extends Spatial

export var smoothedMotion = 5
export var camOffset = 9
export var height = 2
var offsetFr = camOffset
export var mouseSensitivity = 0.1
onready var follow
onready var cam = $SpringArm/Camera

var smoothRot = Vector2()

var mouseVec = Vector2()
var yaw := 0.0
var pitch := 0.0

func _ready():
	$SpringArm.spring_length = camOffset
	$SpringArm/AnimationPlayer.play("Skybox_go_brr",-1,0.5)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	follow = States.currentFollow
	if follow:
		var pos = follow.global_transform.origin + Vector3(0,height,0)
		var own = global_transform.origin
		global_transform.origin += (pos - own) * smoothedMotion * delta
		_do_tha_move()


func _input(event):
	if event is InputEventMouseMotion:
			mouseVec = event.get_relative()
			yaw = yaw  - mouseVec.x * mouseSensitivity
			pitch = clamp((pitch - mouseVec.y * mouseSensitivity),-87,45)
			
			smoothRot = lerp(smoothRot,Vector2(yaw,pitch),1.2)
			yaw = smoothRot.x
			pitch = smoothRot.y
			self.set_rotation(Vector3(deg2rad(pitch), deg2rad(yaw), 0.0))
			
	var x = -Input.get_action_strength("ml") + Input.get_action_strength("mr")
	var y = -Input.get_action_strength("mu") + Input.get_action_strength("md")
	mouseVec = Vector2(x,y)

func _do_tha_move():
		
	yaw = yaw  - mouseVec.x * mouseSensitivity * 20
	pitch = clamp((pitch - mouseVec.y * mouseSensitivity* 20),-87,45)
	
	smoothRot = lerp(smoothRot,Vector2(yaw,pitch),.4)
	yaw = smoothRot.x
	pitch = smoothRot.y
	self.set_rotation(Vector3(deg2rad(pitch), deg2rad(yaw), 0.0))

