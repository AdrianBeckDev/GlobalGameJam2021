extends Spatial


func _process(delta):
	if get_parent().moveable == true:
		match States.event:
			1:
				$AnimationPlayer.play("Slapping",-1,1.5)
			2:
				$AnimationPlayer.play("AssertDominance",0.3)
		if States.event == 0:
			if States.intent.length() > 0.01 && States.grounded:
				var speed = lerp(0.4,1.4,States.momentum)
				$AnimationPlayer.play("Walk",-1,speed)
			else:
				$AnimationPlayer.play("B-Pose",0.1)
