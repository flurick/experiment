
extends Node2D

var codes = [KEY_2, KEY_W, KEY_S, KEY_Z, KEY_CONTROL] # rotated keyboard works nicely :)
var map = []
var bitlife = [0,0,0,0,0]
var bitlifetime = 300

var joke = "haha"
var sience = "aha + haha"
var art = "ahh"


func _ready():
	
	map += ["a","b","c","d","e","f","g","h","i","j","k","l","m"]
	map += ["n","o","p","q","r","s","t","u","v","w","x","y","z"]
	map += ["+","-","-","/","!","."]
	set_process_unhandled_key_input(true)
	
#	generate bit search map based on current input
#	trigger after all complete release, with keys activate within ~300ms

func _unhandled_key_input(e):
	#bits to buttons
	for i in range(codes.size()):
		if e.scancode==codes[i]: 
			find_node(str("Button",i)).set_pressed(e.pressed)
			if e.pressed:  bitlife[i] = bitlifetime
	#bit sum
	var bitsum=0
	if find_node(str("Button0")).is_pressed: bitsum+=1
	if find_node(str("Button1")).is_pressed: bitsum+=2
	if find_node(str("Button2")).is_pressed: bitsum+=4
	if find_node(str("Button3")).is_pressed: bitsum+=8
	if find_node(str("Button4")).is_pressed: bitsum+=16
	
	if bitsum==0:
		printt( str(bitsum).pad_zeros(2), nr2key(bitsum))




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