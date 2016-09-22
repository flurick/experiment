extends "2dshape.gd"

var shape = {
	"0": {"shape":Vector2Array(), "color":Color(1,1,0, 0.3)}
}

var cornerHandleSize = 8
var openShapeID = NONE

func _ready():
	
	var polygon = Polygon2D.new()
	var points = Vector2Array()
	points.append(Vector2(0,100))
	points.append(Vector2(100,0))
	points.append(Vector2(-100,0))
	polygon.set_polygon(points)
	add_child(polygon)
	
	shape["0"] = NewTriangle(500)
	
	M = get_viewport_rect().size / 2
	#set_process(true)
	set_process_unhandled_input(true)


func _process(delta):
	
	#update()
	printt(shape.size(), shape["0"].size())


func NewTriangle(size):
	return Vector2Array([Vector2(-size,0), Vector2(0,-1.6*size), Vector2(size,0)])


func InsertShape(pos, size):
	var backID = str(shape.size())
	status( str("Triangle shape added (", backID, ")") )
	var newshape = Vector2Array()
	newshape.push_back(pos + Vector2(0,-size*1.6))
	newshape.push_back(pos + Vector2(-size,0))
	newshape.push_back(pos + Vector2(size,0))
	shape[backID] = newshape

func status(msg):
	print(msg,"ing")
	get_node("/root/Node/ui/text/status").set_text(msg)


func SmartMove(pos, shp):
	
	if nearPoint == -1 or shp.size() == 0:
		InsertShape(pos, 50)
	else:
		if shp[nearPoint].distance_to(pos) < cornerHandleSize:
			status("mov")
			grabbedID = nearPoint
		else:
			var edgeID = nearEdge[1][1]
			var edgeDistance = nearEdge[0].distance_to(pos)
			if edgeDistance < cornerHandleSize*2:
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
	
	if event.type == InputEvent.MOUSE_MOTION:
		m = event.pos
		if openShapeID != NONE:
			nearPoint = GetClosestPoint(m, shape[openShapeID])
			nearEdge = ClosestPointInShape(m, shape[openShapeID])
#		if corners.size() == 0:  grabbedID = NONE
#		if grabbedID != NONE:  corners[grabbedID] = m
	
	if event.type == InputEvent.MOUSE_BUTTON:
		var btn = event.button_index
		
		if btn == 1:  
			if event.pressed:  
				if openShapeID != NONE:
					if insideShape(m, shape[openShapeID]):
						print("mousing over")
					SmartMove(m, shape["0"])
			else:  
				grabbedID = NONE
				
		if btn == 2:
			if event.pressed:
				if openShapeID != NONE and nearPoint != NONE:
					shape[openShapeID] = filterOut(nearPoint, shape[openShapeID])
			else:  
				pass
	
#	if event.type == InputEvent.KEY:
#		if event.scancode == KEY_F:
#			if event.pressed:
#				editingShape = !editingShape
#				if editingShape:  status("Edit")
#				else:  status("Stop Edit")


#func _draw():
#	
#	print("drawing")
#	draw_colored_polygon(NewTriangle(1000), color.green)
#	
#	for s in shape:
#		draw_rect(Rect2(Vector2(100,100),Vector2(500,500)),Color(0,1,1,0.1))
	


func OLD_draw():
	var size = corners.size()
	if size == 0:
		status("No corners found.")
		#return FAILED
	else:
		DrawShape(corners)
		#draw corners as polygon
		var cornerCount = corners.size()-1
		DrawShape(corners)
		DrawOutline(corners)
		
		nearPoint = GetClosestPoint(m, shape["0"])
		nearEdge = ClosestPointInShape(m, shape["0"])
		
		if corners[nearPoint].distance_to(m) < cornerHandleSize:
			#circle closest corner
			draw_circle(corners[nearPoint], cornerHandleSize/2, color.white)
		else:
			#color nearest normal
			var near = ClosestPointInShape(m, corners)
			draw_line(m, near[0], color.white, 1) #normal
			draw_line(corners[near[1][0]], corners[near[1][1]], color.white, 3) #edge


func gui_pressed_remove():
	corners = filterOut(nearPoint, corners)
