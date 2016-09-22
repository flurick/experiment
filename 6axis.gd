
extends Panel

var w = 100
var h = 100

var r1 = {
	x = 0, y = 0,
	w = 3, h = 3,
	c = Color(0.5, 1.0, 0.5, 0.8)
}

var r2 = {
	x = 0, y = 0,
	w = 0, h = 0,
	c = Color(1.0, 0.5, 0.5, 0.8)
}



func _ready():
	
	set_process_input(true)
	w = get_size().x
	h = get_size().y
	r1.x = w/2
	r1.y = h/2



func _input(e):
	
	if e.type == InputEvent.JOYSTICK_MOTION:
		if e.axis == 0:  r1.w = e.value*w
		if e.axis == 1:  r1.h = e.value*h
		
		r2.x = r1.w/2
		r2.y = r1.h/2
		if e.axis == 2:  r2.w = e.value*w/2
		if e.axis == 3:  r2.h = e.value*h/2
			
		update()
	
	if e.type == InputEvent.JOYSTICK_BUTTON:
		if e.button_index == 5:
			var p = Polygon2D.new()
			var ps = Vector2Array()
			ps.append(Vector2(r2.x,r2.y))
			ps.append(Vector2(r2.w,r2.y))
			ps.append(Vector2(r2.w,r2.h))
			ps.append(Vector2(r2.x,r2.h))
			add_child(p)
		print(e)



func _draw():
	
	drawr(r1)
	drawr(r2)



func drawr(r, c=Color(0.5, 1.0, 0.5, 0.8)):
	
	draw_rect( \
		Rect2( \
			Vector2(r.x, r.y), \
			Vector2(r.w, r.h) \
		), r.c \
	)