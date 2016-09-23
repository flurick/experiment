extends "2dshape.gd"

var handle = { "size":8, "color":Color(0,1,1,0.5) }
var opened = null
var selected = null
var nearest = null
var shape = preload("Polygon2D.tscn")
var mode = {
	group = false,
	delete = false
}

func status(msg):
	print(msg,"ing")
#	if get_node("/root/Node/ui/text/status") != null:
#		get_node("/root/Node/ui/text/status").set_text(msg)


func _ready():
	
	M = get_viewport_rect().size / 2	
	set_process_unhandled_input(true)


func SmartMove(pos, shp):
	
	if nearPoint == -1 or shp.size() == 0:
		InsertShape(pos, 50)
	else:
		if shp[nearPoint].distance_to(pos) < handle.size:
			status("mov")
			grabbedID = nearPoint
		else:
			var edgeID = nearEdge[1][1]
			var edgeDistance = nearEdge[0].distance_to(pos)
			if edgeDistance < handle.size*2:
				status("insert")
				shp = insertCorner(edgeID, shp)
				shp[edgeID] = m
				grabbedID = edgeID
			else:
				status("select")
				#TODO: deselect if outside, select if inside shape
	return shp


func linesCross(lines):
	#TODO
	#input [[a.x,a.y], [b.x,b.y]]
	return

func isOdd(n):
	#TODO
	if n%2==0:
		return true
	else:
		return false

func isInside(somepoint, shape):
#	http://stackoverflow.com/questions/217578/
#	how-can-i-determine-whether-a-2d-point-is-within-a-polygon
#
#	Draw a line from anywhere outside, to your point,
#	and count how often it hits any side of the polygon. 
#	If the number of hits is even, it's outside of the polygon, 
#	if it's odd, it's inside.
	var count = 0
	for i in shape: 
		var line = [shape[i],shape[i+1]] #error
		var insidepoint = [0,0] #somepoint mirror?
		if linesCross(line, line(somepoint, insidepoint)): 
			count+=1
	if count==0 or isOdd(count):
		return false
	else:
		return true


func _unhandled_input(event):
	
	update()
		
	if event.type == InputEvent.MOUSE_MOTION:
		
		# highlight polygon, edge or corner
		m = event.pos
		var nearestDistance = 1000
		for child in get_children():
			if child.is_type("Polygon2D"):
				var distance = m.distance_to(child.get_pos())
				if distance <= nearestDistance:
					nearestDistance = distance
					nearest = child
				child.set_color(Color(0.5,0.5,0.5))
		if nearest!=null and find_node("mouse").get_child_count()==0: nearest.set_color(Color(0,0.5,0.5))
	
	if event.type == InputEvent.MOUSE_BUTTON:
		var btn = event.button_index
		
		if btn == 1: #grabb
			var m = find_node("mouse")
			if event.pressed: 
				status(str(nearest) + "press")
				remove_child(nearest)
				nearest.set_pos(nearest.get_pos()-m.get_pos())
				m.add_child(nearest)
				nearest.set_color(Color(1,1,1,0.8))
			else:
				status("releas")
				for child in m.get_children():
					m.remove_child(child)
					if nearest.get_pos().distance_to(m.get_pos()) < 100:
						nearest.add_child(child)
					else:
						child.set_pos(m.get_pos()+child.get_pos())
						add_child(child)
					
				
		if btn == 2:
			if event.pressed: 
				var polygon = shape.instance()
				add_child(polygon)
				polygon.set_pos(find_node("mouse").get_pos())

	if event.type == InputEvent.KEY:
		if event.scancode == KEY_SPACE:
			opened = find_node("mouse").get_child(0)
			opened.set_color(Color(1,0,0,0.8))
		
		if event.scancode == KEY_G:
			if event.pressed:  mode.group = true
			else:              mode.group = false
			
		if event.scancode == KEY_D:
			if event.pressed:  mode.delete = true
			else:              mode.delete = false
		
		get_node("./mode/group").set_pressed(mode.group)
		get_node("./mode/delete").set_pressed(mode.delete)
		
		

func _draw():
	
	#mark alreay grabbed
	if find_node("mouse").get_child_count() > 0:
		for child in find_node("mouse").get_children():
			draw_line(m,m+child.get_pos(), Color(0,0,0,0.5))
	else:
		if nearest != null:
			draw_line(m,nearest.get_pos(), Color(0,0,0,0.5))
				
	#mark to be grabbed
	for child in get_children():
		draw_line(get_viewport_rect().size/2,child.get_pos(), Color(0,0,0,0.03))

