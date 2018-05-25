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

var hasAxe = false

func _ready():
	$WalkTimer.wait_time = 0.35
	$WalkTimer.start()
	tileMap = get_parent().get_child(0)
	vegMap = get_parent().get_child(1)
	pass


func _physics_process(delta):
	var mov = _updateInput() * 16
	$Label.text = ""
	if canWalk && tileMap.get_cellv(tileMap.world_to_map(position + mov)) != -1:
		move(mov)
	if primary && vegMap.get_cellv(vegMap.world_to_map(position)) != -1:
		if hasAxe:
			vegMap.set_cellv(vegMap.world_to_map(position), -1)
		else:
			say("WOULD BE NICE IF I COULD PICK UP THIS TREE...")
			

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

func say(text):
	$Label.text = str(text)

func _on_WalkTimer_timeout():
	canWalk = true
	pass

func move(m):
	move_and_collide(m)
	canWalk = false
	$WalkTimer.start()