extends Spatial

func _process(delta):
	var momentum = States.momentum
	var animspd = lerp(1.5,0.8,momentum/8)
	
	if !States.grounded:
		$AnimationPlayer.play("Swim",0.2,2)
	else:
		if States.event == 2:
			$AnimationPlayer.play("Honk",-1)
		else:
			if States.intent.length() < 0.01:
				$AnimationPlayer.play("G-Pose",.1,1)
			else:
				match States.event:
					0:
						$AnimationPlayer.play("Walk",.1,2)
					1:
						$AnimationPlayer.play("Nagooso_run",-1,1.5)
