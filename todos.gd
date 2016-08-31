
extends Control

const atodoitem = preload("atodoitem.tscn")

func _ready():
	set_process_unhandled_input(true)

func _unhandled_input(e):
	if e.type == InputEvent.MOUSE_BUTTON \
	and e.doubleclick:
		var i = atodoitem.instance()
		add_child(i)
		i.set_pos(get_global_mouse_pos())