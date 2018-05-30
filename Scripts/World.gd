extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var blockArray
var dic
var treeRate = 8
var treeCounter = 0

var positions = []
var waterRate = 100

onready var Ground = get_node("./Ground")
onready var Vegetation = get_node("./Vegetation")
onready var Animals = get_node("./Animals")
onready var Items = get_node("./Items")

var minWater = 3
var maxWater = 8
var bound = 8 + maxWater

func _ready():
	for x in range(-bound, bound):
		for y in range(-bound, bound):
			$Ground.set_cell(x, y, 0)
	$Ground.update_bitmask_region(Vector2(-bound, -bound), Vector2(bound, bound))
	randomize()


func _process(delta):
#	print(ri(3))
	
	var pos = $Ground.world_to_map($Player.position)
	print(pos)
	var rect = $Ground.get_used_rect()
	
#	print(rect.position)

	if pos.y-bound+1 < rect.position.y:
#		print("on top of map")
		for x in rect.size.x:
			groundSetCell(rect.position.x + x, pos.y - bound + 1, true)
		rect = $Ground.get_used_rect()
		pos = $Ground.world_to_map($Player.position)
	
	if pos.y+bound > rect.position.y + rect.size.y:
#		print("on bottom of map")
		for x in rect.size.x:
			groundSetCell(rect.position.x+x,pos.y + bound - 1, false)
		rect = $Ground.get_used_rect()
		pos = $Ground.world_to_map($Player.position)
	
	if pos.x-bound+1 < rect.position.x:
#		print("on left of map")
		for y in rect.size.y:
			groundSetCell(pos.x-bound+1, rect.position.y + y, true)
		rect = $Ground.get_used_rect()
		pos = $Ground.world_to_map($Player.position)
	
	if pos.x+bound > rect.position.x + rect.size.x:
#		print("on right of map")
		for y in rect.size.y:
			groundSetCell(pos.x+bound-1, rect.position.y+y, false)
		rect = $Ground.get_used_rect()
		pos = $Ground.world_to_map($Player.position)

func groundSetCell(x,y,topleft):
	
	if $Ground.get_cell(x, y) != -1:
		print($Ground.get_cell(x, y))
	
	if $Ground.get_cell(x, y) == -1:
		$Ground.set_cell(x,y,0)
	
	
	if (randi() % treeRate == 0):
		$Vegetation.set_cell(x, y, 0)
	if (randi() % waterRate == 0):
		placeWater(x, y, topleft)
#		positions.append(Vector2(x,y))
	
	
	$Ground.update_bitmask_area(Vector2(x,y))

func placeWater(x0, y0, topleft):
	
	var w = rand_range(minWater, maxWater)
	var h = rand_range(minWater, maxWater)
	
	for x in w:
		for y in h:
			if topleft:
				$Ground.set_cell(x + x0, y + y0, 1);
				$Ground.update_bitmask_area(Vector2(x + x0, y + y0))
				$Vegetation.set_cell(x + x0, y + y0, -1)
			else:
				$Ground.set_cell(x + x0 - w, y + y0 - h, 1);
				$Ground.update_bitmask_area(Vector2(x + x0 - w, y + y0 - h))
				$Vegetation.set_cell(x + x0 - w, y + y0 - h, -1)

func ri(ma):
	return randi() % ma

func _fillMap():
	var rect = $Ground.get_used_rect()
	for x in rect.size.x:
		for y in rect.size.y:
			$Ground.set_cell(x+rect.position.x, y+rect.position.y, 0)