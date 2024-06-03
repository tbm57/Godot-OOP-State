extends Control

var paused = false

func pause():
	$Pause.visible = false
	$Play.visible = true
	
func play():
	$Play.visible = false
	$Pause.visible = true
