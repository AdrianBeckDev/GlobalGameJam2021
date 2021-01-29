extends Node

var spinDir := 0 # 0 none; 1 clockwhise; 2 counterclockwhise

var x := 0.0
var y := 0.0
var lastInput := Vector2()
var counter = 0
var shouldCount := false
var lastCounter := 0.0
var spinTimer := 0.0


func _check_spinput(delta:float, input:Vector2, spinDegrees, spinTime:float = 0.2, onlyCount:bool = false):
	if input != Vector2():
		var inputDelta = atan2(input.x,input.y) - atan2(lastInput.x,lastInput.y)
		
		if inputDelta != 0:
			inputDelta = rad2deg(inputDelta)
			if inputDelta > 180 or inputDelta < -180:
				inputDelta -= sign(inputDelta) * 360
			
			if lastInput != Vector2():
				counter += inputDelta
			else:
				counter = 0
			
			if !onlyCount:
				if abs(lastCounter) > abs(counter):
					spinTimer = 0
				else:
					shouldCount = true
			
			lastCounter = counter
		lastInput =  input
	else:
		counter = 0
	
	if !onlyCount:
		if shouldCount:
			spinTimer += delta
		
		if spinTimer > spinTime:
			counter = 0
			shouldCount = false
	
		_check_spin(spinDegrees)
		
		return spinDir
	else:
		return counter


func _check_spin(degree) -> void:
	if abs(counter) < degree:
		spinDir = 0
	else:
		if counter < degree:
			spinDir = 1
		elif counter > -degree:
			spinDir = -1
		counter = 0
		spinTimer = 0
		shouldCount = false
