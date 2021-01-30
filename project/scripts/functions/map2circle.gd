extends Node

var x := 0.0
var y := 0.0

func _2circle(input) -> Vector2:
	if input.length() != 0:
		if input.length() < 1:
			x = input.x
			y = input.y
			var simpler
			if (abs(x) >= abs(y)):
				simpler = _simpliefy(x)
				x = simpler * pow(x,2)
				y = simpler * x * y
			else:
				simpler = _simpliefy(y)
				x = simpler * x * y
				y = simpler * pow(y,2)
		else:
			x = input.clamped(1).x
			y = input.clamped(1).y
	else:
		x = 0
		y = 0
	
	return Vector2(x,y)

func _simpliefy(xy) -> float:
	return sign(xy) * 1/Vector2(x,y).length()
