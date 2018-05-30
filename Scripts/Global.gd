extends Node

enum ITEMS {STICK, WOOD, COAL, PLANKS}

onready var itemScene = preload("res://Tiles/Item.tscn")

onready var stick = preload("res://Sprites/Items/Stick.png")
onready var wood = preload("res://Sprites/Items/log.png")
onready var coal = preload("res://Sprites/Items/Coal.png")
onready var planks = preload("res://Sprites/Items/Planks.png")

onready var ItemHolder = get_tree().get_root().get_node("World").get_node("ItemHolder")

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
		ITEMS.WOOD:
			var s = itemScene.instance()
			s.name = "WOOD"
			s.type = ITEMS.WOOD
			s.get_child(0).texture = wood
			return s
		ITEMS.COAL:
			var s = itemScene.instance()
			s.name = "COAL"
			s.type = ITEMS.COAL
			s.get_child(0).texture = coal
			return s
		ITEMS.PLANKS:
			var s = itemScene.instance()
			s.name = "PLANKS"
			s.type = ITEMS.PLANKS
			s.get_child(0).texture = planks
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