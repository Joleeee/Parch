extends Button

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Button_button_down():
	
#	var scene = load("res://World.tscn")
#	get_parent().add_child(scene)
#	self.queue_free()
	get_tree().change_scene("res://World.tscn")
	
	pass
