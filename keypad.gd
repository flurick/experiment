
extends Node2D

var raleway = preload("raleway.fnt")
var verdana = preload("verdana.fnt")

var M = Vector2(0,0)
var m = Vector2(0,0)
#var codes = [KEY_F1, KEY_F2, KEY_F3, KEY_F4, KEY_6] # max 2
#var codes = [KEY_A, KEY_S, KEY_D, KEY_F, KEY_SPACE] # space cutof
#var codes = [KEY_SHIFT, KEY_A, KEY_S, KEY_D, KEY_ALT] # space cutof
var codes = [KEY_2, KEY_W, KEY_S, KEY_Z, KEY_CONTROL] # rotated keyboard works nicely :)
var status = [0,0,0,0,0]
var input = [0,0,0,0,0]
var lastinput = [0,0,0,0,0]

var baseInput = []

var history = []

func _ready():
	
	baseInput += ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
	baseInput += ["_","_","_","_","_"]
	
	set_process(true)
	set_process_unhandled_key_input(true)


func _process(delta):
	update()


func _draw():
	m = get_global_mouse_pos()
	M = get_viewport_rect().size / 2
#	draw_line(M,m, Color(1,1,1))
	
	
	var w = 16
	var x = 0
	var y = 0
	
	## list byte input map
	for i in range(0,baseInput.size()):
		x += 1
		if i == 16: 
			y = 1
			x -= 16
		draw_string(verdana, M+Vector2(x*w, y*w), baseInput[i])
	
	## current selected byte
	var c = Color(1,0,0, 0.3)
	var stat = Vector2( list2bin(status)*w,0 )
	var inpu = Vector2( list2bin(input)*w,0 )
	var offset = Vector2(0,0)
	if stat.x > 0:
		if list2bin(status)>16: offset = Vector2(-w*16,w)
		draw_circle(M+stat+offset, w/2, c)
	
	## last entered byte
	var c = Color(1,0,0, 0.6)
	var lastHistory = history.size()-1
	#if lastHistory > -1:
	#	var hist = Vector2( list2bin(history[lastHistory])*w,0 )
	#	draw_circle(M+hist, w/2, c)


func _unhandled_key_input(e):
	
	## activate bits after keyboard show
	var i = 0
	for code in codes:
		if e.scancode == code:
			if e.pressed:
				status[i] = 1
			else:
				status[i] = 0
				input[i] = 1  
				#todo: clear bit soon after relase, to aproximate byte without sending signal, 
				#300ms?, or maybe press other button, like the mouse, to send current
		i += 1
	
	if sum_of(status) == 0:
		#apply
		var n = list2bin(input)
		printt(input, str(n).pad_zeros(2), exec(n-1))
		#reset
		history.push_back(input)
		input = [0,0,0,0,0]


func exec(n):
	if n<baseInput.size() and n>-1:
		return(baseInput[n])


func sum_of(list):
	var sum = 0
	for i in list:
		sum += i
	return sum


func list2bin(list, bigtosmall=true):
	var sum = 0
	var value = 1
	var last = list.size()
	
	if bigtosmall:
		for i in range(last,0,-1):
			if list[i-1]:  
				sum += value
			value *= 2
	else:
		for i in list:
			if i: 
				sum += value
			value *= 2
	
	return sum
