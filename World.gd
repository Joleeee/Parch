extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var blockArray
var dic
var treeRate = 8
var treeCounter = 0

func _ready():
	
	Global.ItemHolder = find_node("ItemHolder")
#	get_tree().set_auto_accept_quit(false)
#	_fillMap()
	randomize()

	pass



func _process(delta):
#	print(ri(3))
	
	var pos = $Ground.world_to_map($Player.position)
	var rect = $Ground.get_used_rect()
#	print(rect.position)

	if pos.y-4 < rect.position.y:
		print("on top of map")
		for x in rect.size.x:
			groundSetCell(rect.position.x + x, pos.y - 4)
		rect = $Ground.get_used_rect()
		pos = $Ground.world_to_map($Player.position)
	
	if pos.y+5 > rect.position.y + rect.size.y:
		print("on bottom of map")
		for x in rect.size.x:
			groundSetCell(rect.position.x+x,pos.y+4)
		rect = $Ground.get_used_rect()
		pos = $Ground.world_to_map($Player.position)
	
	if pos.x-6 < rect.position.x:
		print("on left of map")
		for y in rect.size.y:
			groundSetCell(pos.x - 6, rect.position.y + y)
		rect = $Ground.get_used_rect()
		pos = $Ground.world_to_map($Player.position)
	
	if pos.x+7 > rect.position.x + rect.size.x:
		print("on right of map")
		for y in rect.size.y:
			groundSetCell(pos.x+6, rect.position.y+y)
		rect = $Ground.get_used_rect()
		pos = $Ground.world_to_map($Player.position)
		
	pass

func groundSetCell(x,y):
	$Ground.set_cell(x,y,0)
	$Ground.update_bitmask_area(Vector2(x,y))
	if (randi() % treeRate == 0):
		$Vegatation.set_cell(x, y, 0)
	
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