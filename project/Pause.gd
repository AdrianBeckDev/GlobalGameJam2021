extends Control




func _ready():
	Signals.connect("on_frog_collected",self,"_on_frog_collect")


func _input(event):
	if event.is_action_pressed("ui_select"):
		var new_pause_state = not get_tree().paused 
		get_tree().paused = not get_tree().paused
		$Label.visible = new_pause_state


func _on_frog_collect():
	Signals.frogcounter += 1
	$unhide/Frogcounter.text = ": " + str(Signals.frogcounter)
