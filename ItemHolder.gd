extends Node

onready var item = preload("res://Item.tscn")

onready var stick = preload("res://Stick.png")


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass

func _spawnItem(position, sprite):
	var i = item.instance()
	match sprite:
		Sprites.stick:
#			print("trying to spawn stick")
			i.get_child(0).texture = stick
			i.position = position
			
			var angle = randf() * 360
			var dir = Vector2(cos(angle), sin(angle))
			i.set_linear_velocity(dir * 80) 
			i.type = Sprites.stick
			
			add_child(i)
			
	
	pass

enum Sprites { stick }