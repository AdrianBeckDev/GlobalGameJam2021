extends Control




func _ready():
	Signals.connect("on_frog_collected",self,"_on_frog_collect")


func _input(event):
	var new_pause_state = !get_tree().paused 
	if event.is_action_pressed("ui_select"):
		get_tree().paused = new_pause_state
		$Label.visible = new_pause_state
	if new_pause_state:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_frog_collect():
	Signals.frogcounter += 1
	$unhide/Frogcounter.text = ": " + str(Signals.frogcounter)
