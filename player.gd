
extends Sprite

var walkspeed = 150

func _ready():
	#set_process(true)
	set_process_input(true)
	#print( OS.get_unique_ID() )

func _input(event):
	if event.type == InputEvent.MOUSE_MOTION:
		set_pos(event.pos)

func _process(delta):
	if Input.is_action_pressed("move_left"):
		move_local_x(delta * -walkspeed)
	if Input.is_action_pressed("move_right"):
		move_local_x(delta * walkspeed)