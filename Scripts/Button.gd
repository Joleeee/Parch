extends Button

func _ready():
	pass

#func _process(delta):
#	pass


func _on_Button_button_down():
	get_tree().change_scene("res://World.tscn")