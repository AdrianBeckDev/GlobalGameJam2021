extends Spatial

func _process(delta):
	if get_parent().moveable == true:
		
		if !States.grounded:
			$AnimationPlayer.play("Swim",0.2,2)
		else:
			if States.event == 2:
				$AnimationPlayer.play("Honk",-1)
			else:
				if States.intent.length() < 0.01:
					$AnimationPlayer.play("G-Pose",.1,1)
					$AudioStreamPlayer.play(0.4)
				else:
					match States.event:
						0:
							$AnimationPlayer.play("Walk",.1,2)
						1:
							$AudioStreamPlayer.play(0.4)
							$AnimationPlayer.play("Nagooso_run",-1,1.5)
