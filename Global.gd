extends Node

enum ITEMS {STICK, WOOD, STONE}

onready var itemScene = preload("res://Item.tscn")

onready var stick = preload("res://Stick.png")

var ItemHolder

func _ready():
	pass

func spawnItem(position, item):
	var i = getItem(item)
	i.position = position
	var angle = randf() * 360
	var dir = Vector2(cos(angle), sin(angle))
	i.set_linear_velocity(dir * 80) 
	ItemHolder.add_child(i)

func getItem(item):
	match item:
		ITEMS.STICK:
			var s = itemScene.instance()
			s.name = "STICK"
			s.type = ITEMS.STICK
			s.get_child(0).texture = stick
			return s

func getRecipie(item):
	var file = File.new()
	file.open("res://recipes.csv", file.READ)
	var content
	print(content[0])
	content = file.get_csv_line(";")
	print(content[0])
	print("A")
	file.close()
	return content
	pass