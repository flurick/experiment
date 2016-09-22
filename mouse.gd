
extends Position2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	set_process_input(true)

func _input(e):
	if e.type == InputEvent.MOUSE_MOTION:
		set_pos(e.pos)


