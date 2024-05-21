extends Node2D

var draggable = false
var is_inside_dropable = false
var is_inside_table_one = false
var is_inside_table_two = false
var body_ref
var offset: Vector2
var initialPos: Vector2
var forward = true
var reached = false

@export var speed = 0.5

@onready var patienceTimer = preload("res://patience_animation.tscn")
@onready var patienceInstantiated = false

func _process(delta):
	
	#to make sure the customers dont overlap with each other
	if forward == true:
		get_parent().progress_ratio += speed * delta
	if get_parent().progress_ratio >= (1 - ((global.total_customers - 1)*0.5)):
		forward = false
		if not patienceInstantiated:
			var timerInstance = patienceTimer.instantiate()
			add_child(timerInstance)
			timerInstance.patience_start()
			patienceInstantiated = true
			reached = true
	else:
		forward = true
	
	#dragging code
	if draggable && !global.paused:
		if Input.is_action_just_pressed("click") && global.dragged_objects == 0:
			initialPos = global_position
			offset = get_global_mouse_position() - global_position
			global.is_dragging = true
			#this variable is to ensure that not more than one object is being dragged
			global.dragged_objects += 1
		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("click"):
			global.is_dragging = false
			global.dragged_objects -= 1
			var tween = get_tree().create_tween()
			if is_inside_dropable:
				
				#if the customer is dragged to table one and there is no one at table one
				#and table one is also not dirty
				if is_inside_table_one && global.in_table_one == false && global.table_one_dirty == false:
					global.in_table_one = true
					queue_free()
					global.total_customers -= 1
					#counter to send a signal to the main.gd script
					global.counter += 1
				elif is_inside_table_two && global.in_table_two == false && global.table_two_dirty == false:
					global.in_table_two = true
					queue_free()
					global.total_customers -= 1
					global.counter_2 += 1
				else:
					tween.tween_property(self,"global_position",initialPos,0.2).set_ease(Tween.EASE_OUT)
			else:
				tween.tween_property(self,"global_position",initialPos,0.2).set_ease(Tween.EASE_OUT)
	
	



func _on_area_2d_body_entered(body):
	if body.is_in_group('dropable'):
		is_inside_dropable = true
		body_ref = body
		
	if body.is_in_group('customer_one'):
		is_inside_table_one = true
	elif body.is_in_group('customer_two'):
		is_inside_table_two = true
	

func _on_area_2d_body_exited(body):
	if body.is_in_group('dropable'):
		is_inside_dropable = false
		
	if body.is_in_group('customer_one'):
		is_inside_table_one = false
	elif body.is_in_group('customer_two'):
		is_inside_table_two = false


func _on_area_2d_mouse_entered():
	if not global.is_dragging && global.is_mouse_busy == false && !global.paused && reached:
		draggable = true
		global.is_mouse_busy = true
		scale = Vector2(1.025, 1.025)


func _on_area_2d_mouse_exited():
	if not global.is_dragging && global.is_mouse_busy == true && !global.paused && reached:
		draggable = false
		global.is_mouse_busy = false
		scale = Vector2(1, 1)
