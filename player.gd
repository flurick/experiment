
extends Sprite

var walkspeed = 150

func _ready():
	set_process(true)

func _process(delta):
	if Input.is_action_pressed("move_left"):
		move_local_x(delta * -walkspeed)
	if Input.is_action_pressed("move_right"):
		move_local_x(delta * walkspeed)