extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var up
var down
var left
var right
var primary
var secondary

var canWalk = false
#onready var ItemHolder = get_parent().get_child(4)

var tileMap
var vegMap
var iteMap

var tTimer = 0
var pTimer = 0
var blinkTimer = 0
var blinkTime = 1.5
var blink = false
var paused = false

var hasAxe = false
var hasTorch = false
var hasChainsaw = false
var hasWon = false

var treeDamage = 3
var treeHealth = 3

var chopSounds = []

export var sticks = 00
export var wood = 00
export var coal = 00
export var planks = 0

var stickPrice = 16
var woodPrice = 32
var coalPrice = 64
var plankPrice = 128

var color0 = Color("ffffff")
var color1 = Color("ebff00")

var goal = 0

onready var acquiredSound = preload("res://Audio/magical_1_0.ogg")

func _ready():
	$WalkTimer.wait_time = 0.35
	$WalkTimer.start()
	
#	tileMap = get_parent().Ground
#	vegMap = get_parent().Vegetation
	tileMap = get_node("../Ground")
	vegMap = get_node("../Vegetation")
	iteMap = get_node("../Items")
	print(tileMap)
	print(vegMap)
	
	chopSounds = _loadFiles("res://Audio/Chop/")
#	print(chopSounds)
	setFrame(0)
	setWeapon("None")
	setAnimation(false)
	
	
	
#	pause(10)
	say("GEEZ, I JUST GOT A PAPERCUT :(\nGUESS I'LL JUST HAVE TO DELETE ALL THE TREES!", 10)

func timerUpdate(delta):
	tTimer -= delta
	pTimer -= delta
	blinkTimer -= delta
	if pTimer <= 0:
		paused = false
		$AnimatedSprite.playing = true
		$AnimatedSprite.get_child(0).playing = true
	if tTimer <= 0:
		$Label.text = ""
	pass

func _physics_process(delta):
	timerUpdate(delta)
	
	goal = 0
	if hasAxe:
		goal += 1
	if hasTorch:
		goal += 1
	if hasChainsaw:
		goal += 1
	
	if paused:
		return
	var mov = _updateInput() * 16
	var gro = tileMap.get_cellv(tileMap.world_to_map(position + mov))
	var veg = vegMap.get_cellv(vegMap.world_to_map(position + mov))
	
	if left && !right:
		setFlip(true)
	elif right && !left:
		setFlip(false)
	
	if left || right || up || down:
		setAnimation(true)
	else:
		setAnimation(false)
	
	
	if secondary:
		match goal:
			0:
				if !hasAxe && sticks >= 12:
					hasAxe = true
					sticks -= stickPrice
					setWeapon("Axe")
			1:
				if !hasTorch && wood >= 24:
					hasTorch = true
					wood -= woodPrice
					setWeapon("Torch")
			2:
				if !hasChainsaw && coal >= 42:
					hasChainsaw = true
					coal -= coalPrice
					setWeapon("Chainsaw")
			3:
				if !hasWon && planks >= plankPrice:
					hasWon = true
					planks -= plankPrice
					get_tree().change_scene("res://Credits.tscn")
					#call win function
	
	
	var text = ""
	match goal:
		0:
			if sticks < stickPrice:
				text = "AXE: "+str(stickPrice - sticks)+" STICKS"
			else:
				text = "PRESS C TO CRAFT AXE"
				blink = true
		1:
			if wood < woodPrice:
				text = "TORCH: "+str(woodPrice - wood)+" WOOD"
			else:
				text = "PRESS C TO CRAFT TORCH"
				blink = true
		2:
			if coal < coalPrice:
				text = "CHAINSAW: "+str(coalPrice - coal)+" COAL"
			else:
				text = "PRESS C TO CRAFT CHAINSAW"
				blink = true
		3:
			if planks < plankPrice:
				text = "WIN: "+str(plankPrice - planks)+" PLANKS"
			else:
				text = "PRESS C TO CRAFT WIN (WHAT?)"
				blink = true
	$CraftText.text = text
	
	
	if blink:
		if blinkTimer <= -blinkTime:
			blinkTimer = blinkTime
		
		if blinkTimer <= 0:
			$CraftText.add_color_override("font_color", Color(0,0,0))
		else:
			$CraftText.add_color_override("font_color", color1)
	else:
		$CraftText.add_color_override("font_color", Color(0,0,0))
	
	if primary == true:
		pickUpItems()
	
	if canWalk and gro != -1:
		if veg == 0:
			var typ
			match goal:
				0:
					typ = Global.ITEMS.STICK
				1:
					typ = Global.ITEMS.WOOD
				2:
					typ = Global.ITEMS.COAL
				3:
					typ = Global.ITEMS.PLANKS
			chop(mov, typ)
		else:
			move(mov)
		
		canWalk = false
		$WalkTimer.start()
	
	blink = false

func setFrame(value):
	$AnimatedSprite.frame = value
	$AnimatedSprite/Tool.frame = value

func setAnimation(value):
	$AnimatedSprite.playing = value
	$AnimatedSprite/Tool.playing = value

func setWeapon(weapon):
	$AnimatedSprite/Tool.play(weapon)
	setFrame(0)

func setFlip(value):
	$AnimatedSprite.flip_h = value
	$AnimatedSprite/Tool.flip_h = value
	pass

func chop(mov, itemtype):
	treeDamage -= 1
	say("CHOP", 0.2)
	_playChopSound()
	Global.spawnItem(position+mov, itemtype)
	if treeDamage <= 0:
		vegMap.set_cellv(vegMap.world_to_map(position + mov), -1)
		treeDamage = treeHealth
		say("CHOP!", 1)

func pickUpItems():
	var areas = $Area2D.get_overlapping_areas()
	for x in areas.size():
#		print(areas[x].get_parent().name)
		areas[x].get_parent().queue_free()
		if hasChainsaw:
			if planks == 0:
				pause(3)
				say("YOU AQUIRED PLANKS!", 3, color1)
				$ChopSound.stream = acquiredSound
				$ChopSound.play()
			planks += 1
		elif hasTorch:
			if coal == 0:
				pause(3)
				say("YOU AQUIRED COAL!", 3, color1)
				$ChopSound.stream = acquiredSound
				$ChopSound.play()
			coal += 1
		elif hasAxe:
			if wood == 0:
				pause(3)
				say("YOU AQUIRED WOOD!", 3, color1)
				$ChopSound.stream = acquiredSound
				$ChopSound.play()
			wood += 1
		else:
			if sticks == 0:
				pause(3)
				say("YOU AQUIRED STICKS!", 3, color1)
				$ChopSound.stream = acquiredSound
				$ChopSound.play()
			sticks += 1

func _updateInput():
	var dir = Vector2(0,0)
	up = false
	down = false
	left = false
	right = false
	primary = false
	secondary = false
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
	if Input.is_action_pressed("secondary"):
		secondary = true
	return dir
	pass

func say(text, time, color = null):
	tTimer = time
	$Label.text = str(text)
	if color == null:
		color = color0
	$Label.add_color_override("font_color", color)

func _playChopSound():
	var rand = randi() % chopSounds.size()
	$ChopSound.stream = chopSounds[rand]
	$ChopSound.play()

func pause(time):
	pTimer = time
	$AnimatedSprite.playing = false
	$AnimatedSprite.get_child(0).playing = false
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
#	print("started loading")
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
#		print("file:"+file)
#		print("doesfilestartwith.?"+str(file.begins_with(".")))
#		print("doesfileendwith.import?"+str(file.ends_with(".import")))
#		var a = file
		if file == "":
			break
		if file.ends_with(".wav.import"):
#			print("file is beeing accepted...")
			var sound = load(path+file.replace(".import", ""))
#			print("file is accepted")
#			print(path+file)
			files.append(sound)
#			print(sound)
#!file.begins_with(".") and !file.ends_with(".import"
	
	dir.list_dir_end()
	
	return files