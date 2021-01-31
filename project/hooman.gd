extends Spatial


func _process(delta):
	if !States.grounded:
		if States.event == 3 or sign(States.velocityY) == -1:
			$AnimationPlayer.play("T-Pose",0.2)
		else:
			$AnimationPlayer.play("Jumpu")
	else:
		if States.event == 2:
			$AnimationPlayer.play("Cast",0.1)
		else:
			if States.intent.length() < 0.01:
				$AnimationPlayer.play("idle")
			else:
				match States.event:
					0:
						$AnimationPlayer.play("Walk",.1,1)
					1:
						$AnimationPlayer.play("Run",-1,1.5)
