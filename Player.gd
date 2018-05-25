extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var up
var down
var left
var right
var primary

var canWalk = false

var tileMap
var vegMap
var iteMap

var tTimer = 0
var pTimer = 0
var paused = false

var hasAxe = false
var treeDamage = 3
var treeHealth = 3

var chopSounds = []
func _ready():
	$WalkTimer.wait_time = 0.35
	$WalkTimer.start()
	tileMap = get_parent().get_child(0)
	vegMap = get_parent().get_child(1)
	iteMap = get_parent().get_child(3)
	chopSounds = _loadFiles("res://Audio/Chop/")
	print(chopSounds)
	$ChopSound.stream = chopSounds[1]
	$ChopSound.play()



func _physics_process(delta):
	tTimer -= delta
	pTimer -= delta
	if pTimer <= 0:
		paused = false
	if tTimer <= 0:
		$Label.text = ""
	pickUpItems(position)
	if paused:
		return
	var mov = _updateInput() * 16
	var gro = tileMap.get_cellv(tileMap.world_to_map(position + mov))
	var veg = vegMap.get_cellv(vegMap.world_to_map(position + mov))
	if canWalk and gro != -1:
		if veg == 0:
			treeDamage -= 1
			say("CHOP", 0.2)
			_playChopSound()
			if treeDamage <= 0:
				vegMap.set_cellv(vegMap.world_to_map(position + mov), -1)
				treeDamage = treeHealth
				say("CHOP!", 1)
			pass
		else:
			move(mov)
		
		canWalk = false
		$WalkTimer.start()
	if primary && vegMap.get_cellv(vegMap.world_to_map(position)) != -1: #IF STANDING ON A TREE
		if hasAxe:
			vegMap.set_cellv(vegMap.world_to_map(position), -1)
			say("NEATER!", 2)
			pause(2)
			fill(tileMap, -5, -5, 10, 10)
			tileMap.update_bitmask_region(Vector2(-5,-5), Vector2(5,5))
		else:
			say("WOULD BE NICE IF I COULD PICK UP THIS TREE...", 0)
			iteMap.set_cellv(Vector2(-3,-2), 0)

func pickUpItems(position):
	if primary:
		var pos = iteMap.world_to_map(position)
		var id = iteMap.get_cellv(pos)
		match id:
			0:
				if !hasAxe:
					say("NEAT!", 2)
				hasAxe = true
		iteMap.set_cellv(pos, -1)

func _updateInput():
	var dir = Vector2(0,0)
	up = false
	down = false
	left = false
	right = false
	primary = false
	if Input.is_action_pressed("up"):
		dir.y -= 1
		up = true
	if Input.is_action_pressed("down"):
		dir.y += 1
		down = true
	if Input.is_action_pressed("left"):
		dir.x -= 1
		left = true
	if Input.is_action_pressed("right"):
		dir.x += 1
		right = true
	if Input.is_action_pressed("primary"):
		primary = true
	return dir
	pass

func say(text, time):
	tTimer = time
	$Label.text = str(text)

func _playChopSound():
	var rand = randi() % chopSounds.size()
	$ChopSound.stream = chopSounds[rand]
	$ChopSound.play()

func pause(time):
	pTimer = time
	paused = true

func _on_WalkTimer_timeout():
	canWalk = true
	pass

func move(m):
	move_and_collide(m)

func fill(map, x0, y0, width, height):
	for x in width:
		for y in height:
			map.set_cell(x0+x, y0+y, 0)

func _loadFiles(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif !file.begins_with(".") and !file.ends_with(".import"):
			var sound = load(path+file)
			print(path+file)
			files.append(sound)
			print(sound)
	
	dir.list_dir_end()
	
	return files