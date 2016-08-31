
extends Node2D

var NONE = -1

var m = Vector2(0,0) #mouse
var M = Vector2(0,0) #window center

var corners = Vector2Array()

var nearEdge = [NONE,NONE]
var nearPoint = NONE
var grabbedID = NONE
var moving = false

var color = {
	red = Color(1,0,0),
	blue = Color(0,0,1),
	green = Color(0,1,0),
	white = Color(1,1,1),
	gray = Color(0.5,0.5,0.5),
	black = Color(0,0,0),
}

func _ready():
	pass


# edit


func insertCorner(a, list):
	var lst = Array(list)
	lst.insert(a, lst[a])
	return Vector2Array(lst)


func filterOut(id, list):
	var array = Array(list)
	array.remove(id)
	return Vector2Array(array)


func grabCorner(event):
	if nearPoint == -1:
		moving = false
		grabbedID = -1
	else:
		if event.pressed:
			moving = true
			grabbedID = nearPoint
		else:
			moving = false
			grabbedID = -1

func isPoint(something):
	if something.size() == 1:  return true
	else:  return false

func isLine(something):
	if something.size() == 2:  return true
	else:  return false

func isShape(something):
	if something.size() >= 3:  return true
	else:  return false


#draw


func DrawShape( thing ):
	
	if isShape(thing):  
		draw_colored_polygon(thing, color.green)


func DrawOutline( thing ):
	
	if isLine(thing) or isShape(thing):
		var last = thing.size()-1
		draw_line(thing[0], thing[last], color.green)
		for i in range(0,last):
			draw_line(thing[i], thing[i+1], color.green)


# point


func NearestInShape(shape, target):
	var distance = [].resize(shape.size()+1) #one extra for closed shapes
	var size = distance.size()
	for i in range(0,size):
		distance[i] = shape[i].distance_to(target)
	
	var best = 0
	for i in range(0,size):
		if distance[i] < best:
			best = distance[i]
	
	return best


func ClosestPointInShape(target, shape):
	
	var size = shape.size()
	
	var bestLine = [0,0]
	if size == 0: return Vector2(0,0)
	if size == 1: return [shape[0], [0,0]]
	
	var bestPerLine = Vector2Array()
	for i in range(1,size):
		bestPerLine.push_back( ClosestPointInLine(shape[i], shape[i-1], target) )
	bestPerLine.push_back( ClosestPointInLine(shape[size-1], shape[0], target) )
	
	var bestOverAll = bestPerLine[0]
	var size = bestPerLine.size()
	for i in range(0,size):
		if bestPerLine[i].distance_to(target) <= bestOverAll.distance_to(target):
			bestOverAll = bestPerLine[i]
			bestLine = [i,i+1]
			bestLine[1] = wrap(bestLine[1], 0, size-1)
	
	return [bestOverAll, bestLine]


func ClosestPointInLine(start, end, target):
	#thanks TheMaster42 
	var toStart = target - start
	var toEnd = (end - start).normalized()
	var length = start.distance_to(end)
	var dot = toEnd.dot(toStart)
	
	if dot <= 0:
	 return start
	
	if dot >= length:
	 return end
	
	var v3 = toEnd * dot
	var closest = start + v3
	return closest


#func closer(a, b):
#	
#	return a.distance_to(m) < b.distance_to(m)


func GetClose(target, list, nth):
	
	var lst = Array(list)
	var id = 0
	if nth < lst.size():
		id = lst.sort_custom(self, "closer")
	
	return id


func GetClosestEdgeEnd(target, list):
	# this does not take into account a long and a shord edge next to each other
	var bestID = 0
	
	var i = GetClosest(target, list)
	var a = i-1
	var b = i+1
	var lst = list.size()-1
	
	if lst<2: return 0
	
	if a<0: a=lst
	if a>lst: a=0
	
	if b<0: b=lst
	if b>lst: b=0
	
#	print(a," ",b)
	
	var A = list[a].distance_to(target)
	var B = list[b].distance_to(target)
	
	if A<B:  return a
	else:  return b


func GetSecondClosest(target, list): #nope. this is crazy.
	var lst = filterOut(GetClosest(target, list), list)
	return GetClosest(target, lst)


func GetClosestPoint(target, list): #Vector2 point, Vector2Array list
	var listSize = list.size()
	var bestIndex = 0
	var bestDistance = 0
	
	if listSize > 0:
		
		bestDistance = list[0].distance_to(target)
		for i in range(0,listSize):
			var distance = list[i].distance_to(target)
			if distance < bestDistance:
				bestIndex = i
				bestDistance = distance
	
	return bestIndex

