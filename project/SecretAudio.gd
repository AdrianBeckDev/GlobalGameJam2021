extends Node

var go = false

func _ready():
	Signals.connect("on_music_collected",self,"_on_music_collect")

func _process(_delta):
	if go && !$AudioStreamPlayer.playing && !$AudioStreamPlayer2.playing:
		$AudioStreamPlayer2.play()

func _on_music_collect():
	$AudioStreamPlayer.play()
	go = true
