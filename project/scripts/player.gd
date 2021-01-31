extends KinematicBody


export var listenerHeight = 1.0
# other script
onready var groundCheck := $GroundCheck
var Map2Circle := preload("res:///scripts/functions/map2circle.gd").new()
var Spinput := preload("res:///scripts/functions/spinput.gd").new()
var spinReturn

export var type := "human"

# rng
onready var rng = RandomNumberGenerator.new()

# MoveNSlide
const maxSlides := 4
var groundState := 0
var onSlope := false
var colvel := Vector3()
var normal := Vector3()
var airFric := 1.0
# in Rad
var floor_n := 0.0
export var maxFloor = 70
var maxFloorAngle = deg2rad(maxFloor)
const maxSlopeAngle := 1
#calculate: cos(that radian)
var wallAngle := 0.0
const frontWallAngle := 0.36
const backWallAngle := 0.85

# S T A T E  M A C H I N E
var grounded := false

var intent := Vector2()
var velocityXZ := Vector2()
var velocityY := 0.0

# Buffer
var wasGrounded := 0.0
const coyoteTime := 0.1
const inputBufferTime := 0.07
var jumpBuffer := 0.0
var spinBuffer := 0.0

# Movement
var gravity = 55
var gravmod := 1.0
var grav := 1.0
export var speed := 17.7
var spd := 1.0

# Acceleration
var cel := 1.0
var celmod := 1.0
#var celconSlowdown = 1
export var constAccel := 4
export var constDecel := 7
var accel = constAccel
var decel = constDecel

#turning
var turnspeed :float
var turnspd := 1.0
export var turnLow := .07
export var turnHigh := 1.2
var spinDir := 1

#jumping
export var canJump = true
var jump = 1
export var minJump = 10
export var maxJump = 19
export var spinjump = 25


func _ready():
	$Listener.transform.origin.y = listenerHeight


func _input(event):
	#print(sqrt(2 * gravity * 6.5))
	var x = -Input.get_action_strength("left") + Input.get_action_strength("right")
	var y = -Input.get_action_strength("up") + Input.get_action_strength("down")
	
	var camBasis = Basis(get_viewport().get_camera().global_transform.basis)
	intent = x*Vector2(camBasis.x.x,camBasis.x.z).normalized() + y*Vector2(camBasis.z.x,camBasis.z.z).normalized()
	intent = Map2Circle._2circle(intent)
	
	States.intent = intent
	
	if Input.is_action_just_pressed("jump"):
		jumpBuffer = inputBufferTime
	if !Input.is_action_pressed("jump") && jumpBuffer < 0.03:
		jumpBuffer = 0


func _process(delta):
	_spinput(delta)
	_buffer(delta)
	_move(delta)
	_character(delta)
	_move_and_slide(delta)


func _character(delta):
	match type:
		"human":
			_human()
		"goose":
			_goose()

func _human():
	if Input.is_action_pressed("action1") && grounded:
		spd = 2.4
		States.event = 1
	else:
		spd = 1
		States.event = 0
	if Input.is_action_pressed("action2") && grounded:
		States.event = 2
		velocityXZ = Vector2()
		#cast


func _goose():
	if Input.is_action_pressed("action1") && grounded:
		spd = 1.7
		States.event = 1
	else:
		spd = 1
		States.event = 0
	if Input.is_action_pressed("action2") && grounded:
		States.event = 2
		velocityXZ = Vector2()


func _spinput(delta) -> void:
	spinReturn = Spinput._check_spinput(delta,intent,270)
	if spinReturn != 0:
		spinBuffer = 0.3
		spinDir = -spinReturn


#Buffer
func _buffer(delta) -> void:
	wasGrounded -= delta
	jumpBuffer = _time_buffer(delta,jumpBuffer)
	spinBuffer = _time_buffer(delta,spinBuffer)

func _time_buffer(delta,buffer) -> float:
	if buffer > 0:
		buffer -= delta
	else:
		buffer = 0
	
	return buffer


func _move(delta) -> void:
#movin' including accel
	var intMove = intent*speed*spd
	if grounded:
		accel = constAccel
		decel = constDecel
	else:
		accel = lerp(0.2,constAccel,intent.length())
		decel = 0

	if velocityXZ.length() < intMove.length():
		cel = accel 
	else:
		cel = decel
	if decel == 0 && intent.length() > 0.1:
		cel = 4

	velocityXZ = lerp(velocityXZ,intMove,cel*celmod*delta)
	
	var momentum := velocityXZ.length()
	var normMomentum := pow(clamp(momentum,0,speed)/speed,2)
#turnin'
	turnspeed = lerp(turnHigh,turnLow,normMomentum)/10*turnspd
	
	if turnspeed != 0:
		if intent.length() != 0:
			_rotate(atan2(intent.x,intent.y))
#check groundstate and common behaviour for said state
	if grounded:
		jump = lerp(0.8,1,normMomentum)
		velocityY = 0
		wasGrounded = coyoteTime


#gravitatin'
	if !grounded:
		velocityY -= gravity*gravmod*grav*delta
		velocityY = clamp(velocityY,-150,50)

	if canJump:
		if wasGrounded > 0:
			if jumpBuffer > 0:
				jumpBuffer = 0
				_offground()
				if spinBuffer > 0:
					States.event = 3
					velocityY = spinjump * jump
				else:
					velocityY = maxJump * jump
	
		if Input.is_action_just_released("jump") && velocityY > minJump * jump:
			velocityY = minJump * jump
	
	if !Input.is_action_pressed("jump") && velocityY < 0:
		gravmod = 1.1
	else:
		gravmod = 1

	States.momentum = momentum
	States.grounded = grounded
	States.velocityY = velocityY



func _move_and_slide(delta):
	var colY :KinematicCollision
	var counter = 0
	var motion = Vector3(velocityXZ.x,velocityY,velocityXZ.y) * delta
	while motion.length() != 0:
		var col = move_and_collide(motion,false) as KinematicCollision
		
		if col:
			var remainder = col.get_remainder() as Vector3
			normal = col.get_normal()
			groundState = _checkfloor(normal)
			
			match groundState:
				1,2:
					var slopeUp = 0
					var slopeDebug = tan(deg2rad(90)-floor_n)
					if slopeDebug != 0:
						slopeUp = remainder.length()/(2*slopeDebug)
					colY = move_and_collide(Vector3(0,slopeUp,0),false)
					motion = Vector3(remainder.x,0,remainder.z)
				3:
					motion = remainder.slide(normal)
				4:
					velocityY = 0
					motion = remainder.slide(normal)
			
			#push stuff
			if col.collider is RigidBody:
				col.collider.apply_central_impulse(-col.normal*0.3)
		else:
			motion = Vector3()
			if counter == 0:
				floor_n = 0
				groundState = 0
			
			#moving ground & stepping O.O
			#step down
			if grounded:
				colY = move_and_collide(Vector3(0,-0.4,0),false,true,true)
				if colY:
					var yState = _checkfloor(colY.get_normal())
					if yState != 3:
						move_and_collide(Vector3(0,-0.2,0),false)
						if yState == 2:
							move_and_collide(Vector3(0,colY.get_position().y - self.global_transform.origin.y,0),false)
							groundState = yState
				#checkground velocity
				if colY:
					if colY.collider.is_in_group("movinplatforms"):
						colvel = colY.collider.velocity
					else:
						colvel = colY.get_collider_velocity()
					
					airFric = 1
			else:
				airFric -= 0.2*delta
				airFric = clamp(airFric,0,1)
			if colvel:
				if counter < maxSlides - 1:
					counter = maxSlides - 1
					motion += colvel*airFric*delta
		
		if counter == maxSlides:
			break
		counter += 1
	
	if !groundCheck.is_colliding() && groundState != 2:
		grounded = false


#Check col normal
func _checkfloor(colNormal) -> int:
	var colState = 0
	floor_n = acos(colNormal.dot(Vector3.UP))
	
	if colState == 2:
		grounded = true
	
	if floor_n <= maxFloorAngle:
		if floor_n > maxSlopeAngle:
			onSlope = true
		else:
			onSlope = false
		colState = 1
	elif acos(colNormal.dot(-Vector3.UP)) <= maxFloorAngle:
		colState = 4
	else:
		colState = 3
	if colState == 1:
		grounded = true
		if !groundCheck.is_colliding():
			colState = 2
	
	return colState


#rotate
func _rotate(rotTo) -> void:
		var rot = rad2deg(self.get_rotation().y - rotTo)
		if abs(rot) > 180:
			rotTo += sign(rot) * deg2rad(360)
		if grounded && velocityXZ.length() > 0.1 && abs(rot) >= 120 && abs(rot) <= 300:
			pass
		if abs(rot) >= 179 && abs(rot) <= 181:
			rng.randomize()
			if rng.randi_range(0,1) == 1:
				rotTo += deg2rad(360)
		var rotateTo = lerp(self.get_rotation().y,rotTo,turnspeed)
		self.set_rotation(Vector3(0,rotateTo,0))


#leaveGround
func _offground() -> void:
	wasGrounded = 0
	grounded = false


#Forward
func _dash(amount,height) -> void:
	velocityY = height
	velocityXZ.x = get_global_transform().basis.z.x * amount
	velocityXZ.y = get_global_transform().basis.z.z * amount
