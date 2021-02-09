extends Spatial

func _ready():
	States.hooman = self.get_parent()

func _process(_delta):
	if get_parent().moveable == true:
		if !States.grounded:
			$AnimationPlayer.play("Fallu")
		else:
			if States.event == 2:
				$AnimationPlayer.play("Cast",0.1,2)
			else:
				if States.intent.length() < 0.01:
					$AnimationPlayer.play("idle")
				else:
					match States.event:
						0:
							var speed = lerp(0.5,1.3,States.momentum)
							$AnimationPlayer/AudioStreamPlayer.pitch_scale = 0.3
							$AnimationPlayer/AudioStreamPlayer2.pitch_scale = 0.32
							$AnimationPlayer.play("assetsWalk",.1,speed)
						1:
							if States.momentum < 0.6:
								$AnimationPlayer/AudioStreamPlayer.pitch_scale = 0.32
								$AnimationPlayer/AudioStreamPlayer2.pitch_scale = 0.3
								var speed = lerp(0.5,1.3,States.momentum)
								$AnimationPlayer.play("Walk",.1,speed)
							else:
								$AnimationPlayer/AudioStreamPlayer.pitch_scale = 0.4
								$AnimationPlayer/AudioStreamPlayer2.pitch_scale = 0.38
								var speed = lerp(0.1,1.8,States.momentum)
								$AnimationPlayer.play("assetsRun",-1,speed)
