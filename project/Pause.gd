extends Control



func _input(event):
	if event.is_action_pressed("ui_select"):
		var new_pause_state = not get_tree().paused 
		get_tree().paused = not get_tree().paused
		$Label.visible = new_pause_state
	
