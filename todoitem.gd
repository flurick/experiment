
extends Control

var move = false
var resize = false
var offset = Vector2(0,0)
var delta = Vector2(0,0)

func _ready():
	#connect("input_event",self,"_on_input_event")
	set_process_input(true)
	popup()

#func _on_input_event( e ):
func _input_event(e):
		
	if e.type == InputEvent.MOUSE_BUTTON:
		if e.button_index == 1:
			if e.pressed:
				move = true
				accept_event()
				offset = get_pos() - get_global_mouse_pos()
			else:
				move = false
		if e.button_index == 2:
			if e.pressed:
				resize = true
				accept_event()
			else:
				resize = false
	
	if e.type == InputEvent.KEY and e.pressed:
		print("key pressed")
		if e.scancode == KEY_ENTER-1: #what is this KEY_ENTER offset?
			
			var new = duplicate()
			#get_parent().add_child(new)
			new
			new.set_text("")
			new.grab_focus()
			
			var offset = get_size()
			offset.x = 0
			new.set_pos( get_pos() + offset )
			
			print("Created new note.")
	
	if e.type == InputEvent.MOUSE_MOTION and move:
		set_pos( get_global_mouse_pos() + offset )
		
	if e.type == InputEvent.MOUSE_MOTION and resize:
		set_size( get_local_mouse_pos() )