
extends Control

var draging = false
var offset = Vector2(0,0)
var delta = Vector2(0,0)

func _ready():
	connect("input_event",self,"_on_input_event")

func _on_input_event( e ):
	
	if e.type == InputEvent.MOUSE_BUTTON:
		if e.pressed:
			draging = true
			offset = get_pos() - get_global_mouse_pos()
		else:
			draging = false
	
	if e.type == InputEvent.KEY and e.pressed:
		if e.scancode == KEY_ENTER-1: #lol what is this KEY_ENTER offset?
			
			var new = duplicate()
			get_parent().add_child(new)
			new.set_text("")
			new.grab_focus()
			
			var offset = get_size()
			offset.x = 0
			new.set_pos( get_pos() + offset )
			
			print("Created new note.")
	
	if e.type == InputEvent.MOUSE_MOTION and draging:
#		print(e)
		set_pos( get_global_mouse_pos() + offset )
