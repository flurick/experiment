
extends Control

var codes = [KEY_2, KEY_W, KEY_S, KEY_Z, KEY_CONTROL] # rotated keyboard works nicely :)
var map = []
var bitlife = [0,0,0,0,0]
var bitlifetime = 0.1

var joke = "haha"
var sience = "aha + haha"
var art = "ahh"


func _ready():
	
	map += ["a","b","c","d","e","f","g","h","i","j","k","l","m"]
	map += ["n","o","p","q","r","s","t","u","v","w","x","y","z"]
	map += ["+","-","-","/","!"]
	set_process_unhandled_key_input(true)
	set_process(true)

func _process(d):
	for i in range(bitlife.size()):
		if bitlife[i] > 0: 
			bitlife[i] -= d
			find_node(str("Button",i)).set_flat(false)
		else:
			bitlife[i] = 0
			find_node(str("Button",i)).set_flat(true)
#		find_node(str("Button",i)).set_text(str(bitlife[i]))
	
#	generate bit search map based on current input
#	trigger after all complete release, with keys activate within ~300ms

func _unhandled_key_input(e):
	
	#bits to buttons
	for i in range(codes.size()):
		if e.scancode==codes[i]: 
			bitlife[i] = bitlifetime
			find_node(str("Button",i)).set_pressed(e.pressed)
	
	
	#bit sum of pressed buttons
	var input=0
	if find_node(str("Button0")).is_pressed: input+=1
	if find_node(str("Button1")).is_pressed: input+=2
	if find_node(str("Button2")).is_pressed: input+=4
	if find_node(str("Button3")).is_pressed: input+=8
	if find_node(str("Button4")).is_pressed: input+=16
	
	if input==0: 
		var n = list2bin(bitlife)
		printt( nr2key(n-1) )
	
#	printt( str(pressedbitsum).pad_zeros(2), \
#	str(livebitsum).pad_zeros(2), \
#	nr2key(livebitsum),\
#	bitlife)




### helpers below 


func nr2key(n):
	if n<map.size() and n>-1:
		return(map[n])


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