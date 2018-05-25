extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var up
var down
var left
var right

var canWalk = false

var tileMap

func _ready():
	$WalkTimer.wait_time = 0.35
	$WalkTimer.start()
	tileMap = get_parent().get_child(0)
	pass


func _physics_process(delta):
	var mov = _updateInput() * 16
	if canWalk && tileMap.get_cellv(tileMap.world_to_map(position + mov)) != -1:
		move_and_collide(mov)
		canWalk = false
		$WalkTimer.start()
	pass

func _updateInput():
	var dir = Vector2(0,0)
	up = false
	down = false
	left = false
	right = false
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
	return dir
	pass

func _on_WalkTimer_timeout():
	canWalk = true
	pass
