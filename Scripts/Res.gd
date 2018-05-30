extends Button

# class member variables go here, for example:
# var a = 2
# var b = "textvar"


func _ready():
	OS.set_window_size(Vector2(96*4, 64*4))
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

var m = 1
var scale = 4
func _on_Res_button_down():
	scale += 2 * m
	if scale > 8:
		scale = 8
		m *= -1
	if scale < 4:
		scale = 4
		m *= -1
	
	OS.set_window_size(Vector2(96*scale, 64*scale))
	pass # replace with function body
