extends Control

var cursorPos = 0

func _ready():
	get_tree().paused = true

func _input(event):
	if Input.is_action_just_pressed("up"):
		cursorPos -= 1
	if Input.is_action_just_pressed("down"):
		cursorPos += 1
	cursorPos = clamp(cursorPos,1,3)
	
	#$referenc.visible = false
	match cursorPos:
		1:
			if Input.is_action_just_pressed("ui_accept"):
				get_tree().paused = false
				self.visible = false
		2:
			pass
		3:
			pass
	print(cursorPos)
