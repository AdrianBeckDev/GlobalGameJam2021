extends Node

var x := 0
var y := 0

func _2circle(input) -> Vector2:
	if input.length() != 0:
		x = sign(input.x)
		y = sign(input.y)
		var strength
		input = Vector2(abs(input.x),abs(input.y))
		if input.x > input.y:
			strength = input.x
		else:
			strength = input.y
		input += input.normalized() * (strength-input.length())
		input *= Vector2(x,y)
	
	return input
