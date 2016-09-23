
extends VisualScript 

export var x = 10 
add_custom_signal("y")

func _ready():
	add_variable("x")
	add_custom_signal("y")

func rectangle():
	draw_rect(Vector2(get_viewport_rect().size/3), Vector2(get_viewport_rect().size/3*2), Color(1,1,0,0.3),  3)


