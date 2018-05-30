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

var minWater = 0
var maxWater = 0

func _ready():
	randomize()


func _process(delta):
#	print(ri(3))
	
	var pos = $Ground.world_to_map($Player.position)
	var rect = $Ground.get_used_rect()
#	print(rect.position)

	if pos.y-4-maxWater < rect.position.y:
#		print("on top of map")
		for x in rect.size.x:
			groundSetCell(rect.position.x + x, pos.y - 4-maxWater)
		rect = $Ground.get_used_rect()
		pos = $Ground.world_to_map($Player.position)
	
	if pos.y+5+maxWater > rect.position.y + rect.size.y:
#		print("on bottom of map")
		for x in rect.size.x:
			groundSetCell(rect.position.x+x,pos.y+4+maxWater)
		rect = $Ground.get_used_rect()
		pos = $Ground.world_to_map($Player.position)
	
	if pos.x-6-maxWater < rect.position.x:
#		print("on left of map")
		for y in rect.size.y:
			groundSetCell(pos.x-6-maxWater, rect.position.y + y)
		rect = $Ground.get_used_rect()
		pos = $Ground.world_to_map($Player.position)
	
	if pos.x+7+maxWater > rect.position.x + rect.size.x:
#		print("on right of map")
		for y in rect.size.y:
			groundSetCell(pos.x+6+maxWater, rect.position.y+y)
		rect = $Ground.get_used_rect()
		pos = $Ground.world_to_map($Player.position)
		
	updateWater()

func groundSetCell(x,y):
	
	if $Ground.get_cell(x, y) != -1:
		print($Ground.get_cell(x, y))
	
	if $Ground.get_cell(x, y) == -1:
		$Ground.set_cell(x,y,0)
	
	
	if (randi() % treeRate == 0):
		$Vegetation.set_cell(x, y, 0)
	if (randi() % waterRate == 0):
		placeWater(x, y)
#		positions.append(Vector2(x,y))
	
	
	$Ground.update_bitmask_area(Vector2(x,y))

func placeWater(x0, y0):
	
	var w = rand_range(minWater, maxWater)
	var h = rand_range(minWater, maxWater)
	
	for x in w:
		for y in h:
			$Ground.set_cell(x + x0, y + y0, 1);
			$Ground.update_bitmask_area(Vector2(x + x0, y + y0))
	
	pass
#	var radius = 4
#	for y in range(-radius, radius):
#		for x in range(-radius, radius):
#			if (x*x) + (y*y) <= (radius * radius):
#				$Ground.set_cell(x0 + x, y0 + y, 1);
	
#	var radius = 3
#	var x = radius-1
#	var y = 0
#	var dx = 1
#	var dy = 1
#	var err = dx - (radius << 1)
#
#	while x >= y:
#		$Ground.set_cell(x0 + x, y0 + y, 1);
#		$Ground.set_cell(x0 + y, y0 + x, 1);
#		$Ground.set_cell(x0 - y, y0 + x, 1);
#		$Ground.set_cell(x0 - x, y0 + y, 1);
#		$Ground.set_cell(x0 - x, y0 - y, 1);
#		$Ground.set_cell(x0 - y, y0 - x, 1);
#		$Ground.set_cell(x0 + y, y0 - x, 1);
#		$Ground.set_cell(x0 + x, y0 - y, 1);
#		$Ground.update_bitmask_region(Vector2(x0-x, y0-y), Vector2(x0+x, y0+y))
#
#		if err <= 0:
#			y += 1
#			err += dy
#			dy += 2
#
#		if err > 0:
#			x -= 1
#			dx += 2
#			err += dx - (radius << 1)
	
	
	
	
#	for x0 in x:
#		for y0 in y:
#
#
#	var r = 3
#	for x0 in range(-r, r):
#		for y0 in range(-r, r):
#			print(Vector2(x0+x, y0+y).distance_to(Vector2(x,y)))
#			if Vector2(x0+x, y0+y).distance_to(Vector2(x,y)) <= r*16:
#				$Ground.set_cell(x0+x, x0+x, 1)
	
#	$Ground.set_cell(x, y, 1)
#	$Ground.update_bitmask_area(Vector2(x, y))
#	$Ground.update_bitmask_region(Vector2(x-r, y-r), Vector2(x+r, y+r))

func updateWater():
	pass
#	for n in positions.size():
#		$Ground.update_bitmask_area(Vector2(positions[n].x, positions[n].y))
	
#	print(positions.size())
#	var rect = $Ground.get_used_rect()
#	for x in rect.size.x:
#		for y in rect.size.y:
#			var value = false
#			for n in positions.size():
#				var dist = positions[n].distance_to(Vector2(x + rect.position.x, y + rect.position.y))
#				print(dist)
#				if dist == 0:
#					return
#				if 5/dist >= 1:
#					$Ground.set_cellv(positions[n], 1)
#					$Ground.update_bitmask_area(Vector2(positions[n].x, positions[n].y))
#					print("yep")

	
#	for n in positions.size():
#		$Ground.set_cellv(positions[n], 1)
#		$Ground.update_bitmask_area(Vector2(positions[n].x, positions[n].y))


func ri(ma):
	return randi() % ma

func _fillMap():
	var rect = $Ground.get_used_rect()
	for x in rect.size.x:
		for y in rect.size.y:
			$Ground.set_cell(x+rect.position.x, y+rect.position.y, 0)

#func _makeArray(width, heigth, fill):
#	var matrix = []
#	for x in range(width):
#	    matrix.append([])
#	    for y in range(height):
#	        matrix[x].append(fill)
#	return matrix