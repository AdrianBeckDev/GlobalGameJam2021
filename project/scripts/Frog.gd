extends Spatial


onready var rng = RandomNumberGenerator.new()
var can = true

func _on_Area_body_entered(body):
	if can:
		if body.name == "Player":
			
			can = false
			$Frog.visible = false
			$quack.playing = true
			for i in 14:
				var ins = get_child(i)
				ins.visible = true
				ins.frame = rng.randf_range(1,7)
				ins.transform.origin.x = rng.randf_range(-100,100)/100
				ins.transform.origin.y = rng.randf_range(-100,100)/100
				ins.transform.origin.z = rng.randf_range(-100,100)/100
				ins.playing = true
		$Timer.start()




func _on_Timer_timeout():
	self.queue_free()
