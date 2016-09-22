
extends Control

var codes = [KEY_2, KEY_W, KEY_S, KEY_Z, KEY_CONTROL] # rotated keyboard works nicely :)
#var codes = [KEY_A, KEY_S, KEY_D, KEY_F, KEY_ALT] #space limit
var map = []
var bitlife = [0,0,0,0,0]
var bitlifetime = 0.3

var joke = "haha"
var sience = "aha + haha"
var art = "ahh"

# ideas
#generate bit search map based on current input
#trigger new input event

func _ready():
	
	map += ["a","b","c","d","e","f","g","h","i","j","k","l","m"]
	map += ["n","o","p","q","r","s","t","u","v","w","x","y","z"]
	map += ["+","-","*","/","!"]
	set_process_unhandled_key_input(true)
	set_process(true)
	
	var l = find_node("list")
	var t = find_node("text")
	for i in range(map.size()):
		var help = str(dec2bin(i), " : ", map[i], "\n")
		var item = Label.new()
		item.set_text(help)
		l.add_child(item)
		l.set_size( Vector2(128,10) )


func _process(d):
	
	for i in range(bitlife.size()):
		if bitlife[i] > 0: 
			bitlife[i] -= d
			find_node(str("Button",i)).set_flat(false)
		else:
			bitlife[i] = 0
			find_node(str("Button",i)).set_flat(true)


func _unhandled_key_input(e):
	
	if e.pressed:
		print(e)
	
	#bits to buttons
	for i in range(codes.size()):
		if e.scancode==codes[i]: 
			bitlife[i] = bitlifetime
			find_node(str("Button",i)).set_pressed(e.pressed)
#			if e.pressed: input += pow(2,i)
		
			#filter map
#			for j in get_node("list").get_children():
#				print(j.get_text().ord_at(i))
#				if j.get_text().ord_at(i) == 1:
#					j.set_opacity(0.5)
#	
	var input=0 #the value of the 5 bits of your fingers
	for i in range(get_child_count()-1):
		if find_node(str("Button",i)).is_pressed():
			input += pow(2,i)
		
	if input==0: 
		var n = list2bin(bitlife, true)
		printt( nr2key(n-1) )
		bitlife = [0,0,0,0,0]
	
	#print(input)




### helpers below 


func nr2key(n):
	if n<map.size() and n>-1:
		return(map[n])


func sum_of(list):
	var sum = 0
	for i in list:
		sum += i
	return sum

func dec2bin(n):
	var b
	if n==31: b="11111"
	if n==30: b="11110"
	if n==29: b="11101"
	if n==28: b="11100"
	if n==27: b="11011"
	if n==26:b="11010"
	if n==25:b="11001"
	if n==24:b="11000"
	if n==23:b="10111"
	if n==22:b="10110"
	if n==21:b="10101"
	if n==20:b="10100"
	if n==19:b="10011"
	if n==18:b="10010"
	if n==17:b="10001"
	#
	if n==16:b="10000"
	if n==15:b="01111"
	if n==14:b="01110"
	if n==13:b="01101"
	if n==12:b="01100"
	if n==11:b="01011"
	if n==10:b="01010"
	if n==9: b="01001"
	#
	if n==8: b="01000"
	if n==7: b="00111"
	if n==6: b="00110"
	if n==5: b="00101"
	#
	if n==4: b="00100"
	if n==3: b="00011"
	if n==2: b="00010"
	if n==1: b="00001"
	if n==0: b="00000"
	return  b


func list2bin(list, bigtosmall=true):
	var sum = 0
	var value = 1
	var last = list.size()
	
	print("b2s ", bigtosmall)
	
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

