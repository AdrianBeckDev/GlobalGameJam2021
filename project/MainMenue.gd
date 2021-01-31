extends Control


#var scene = preload("res://Main.tscn").instance()


var cursorPos = 0

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
				#get_tree().get_root().get_child(0).add_child("res://Map")
				self.queue_free()
		2:
			pass
		3:
			pass
	print(cursorPos)
