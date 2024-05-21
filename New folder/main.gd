extends PathFollow2D

const speed = 0.8
const customer_one_spot = 0.7
const customer_two_spot = 1

var customer_one_trigger = false
var customer_two_trigger = false

var order = false
var order_two = false
var food = 0
var eating_one = false
var eating_two = false
var food_finished = false
var food_finished_two = false

var on = true

@onready var customer_one: Button = $"../../Button"
@onready var customer_two: Button = $"../../Button2"
@onready var order_button: Button = $"../../Button3"
@onready var customerTimer: Timer = $"../../CustomerTimer"
@onready var seatingTimer : Timer = $"../../SeatingTimer"
@onready var orderTimer: Timer = $"../../OrderTimer"

#timer for each customer
@onready var eatingTimer: Timer = $"../../EatingTimer"
@onready var eatingTimer_2: Timer = $"../../Eating2Timer"

@onready var health = load("res://lives.tscn")
@onready var score = load("res://score.tscn")
@onready var progress_bar = load("res://progress_bar.tscn")
@onready var pause_menu = $"../../Camera2D/MenuScreen"

func _ready():
	on = false
	buttons(0)
	progress_ratio = 0
	var tempHealth = health.instantiate()
	add_child(tempHealth)
	var tempScore = score.instantiate()
	add_child(tempScore)
	var tempBar = progress_bar.instantiate()
	add_child(tempBar)
	tempBar.progress_start()

func _process(delta):
	
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
	
	#player going forwards
	if global.is_forwards == true && on == true:
		progress_ratio += delta * speed
		
		#if player is at the customer spot then stop
		if customer_one_trigger == true && progress_ratio >= customer_one_spot && global.is_forwards == true:
			off_switch()
			customerTimer.start()
		elif customer_two_trigger == true && progress_ratio == customer_two_spot && global.is_forwards == true:
			off_switch()
			customerTimer.start()
			
	#player going backwards
	elif global.is_forwards == false:
		progress_ratio -= delta * speed
		
		#if player is back at starting spot
		if progress_ratio == 0:
			off_switch()
			buttons(1)
			refresh()
			global.is_forwards = true
			if order || order_two:
				order_button.disabled = false
	
	#if there is someone present at the table
	if global.in_table_one && global.counter > 0:
		seatingTimer.start()
		customer_one.text = "customer (seated)"
		global.counter -= 1
		
	if global.in_table_two && global.counter_2 > 0:
		seatingTimer.start()
		customer_two.text = "customer 2 (seated)"
		global.counter_2 -= 1

func pauseMenu():
	if global.paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	
	global.paused = !global.paused

func _on_button_pressed():
	
	#player will move if they're at the start spot, 
	#there is someone at the table,
	#order hasn't been received
	#or if they are currently not eating 
	if progress_ratio == 0 && global.in_table_one == true && order == false && eating_one == false && !global.paused:
		on_switch()
		buttons(0)
		customer_one_trigger = true

func _on_button_2_pressed():
	
	if progress_ratio == 0 && global.in_table_two == true && order_two == false && eating_two == false && !global.paused:
		on_switch()
		buttons(0)
		customer_two_trigger = true

func _on_button_3_pressed():
	
	#if anyone is ordering and there is no food, then make order
	if (order == true || order_two == true) && food == 0 && !global.paused:
		buttons(0)
		orderTimer.start()
		

func _on_customer_timer_timeout():
	if customer_two_trigger == true && progress_ratio == customer_two_spot:
		on_switch()
		global.is_forwards = false
		if global.table_two_dirty:
			customer_two.text = "customer 2"
			global.in_table_two = false
			global.table_two_dirty = false
			food_finished_two = false
		elif food_finished_two:
			print("customer paid")
			customer_two.text = "customer 2 (dirty)"
			global.table_two_dirty = true
			global.customer_paid += 1
		elif food == 1:
			customer_two.text = "customer 2 (eating)"
			order_button.text = "make order"
			eating_two = true
			food -= 1
			eatingTimer_2.start()
		elif global.in_table_two:
			customer_two.text = "customer 2 (order)"
			if eating_two == false:
				order_two = true
	
	#if player is at the customer spot and there is a customer there
	if customer_one_trigger == true && progress_ratio >= customer_one_spot:
		
		#go back to their starting position
		on_switch()
		global.is_forwards = false
		
		#if table is dirty
		if global.table_one_dirty:
			customer_one.text = "customer"
			global.in_table_one = false
			global.table_one_dirty = false
			food_finished = false
		
		#if their food is finished
		elif food_finished:
			print("customer paid")
			customer_one.text = "customer (dirty)"
			global.table_one_dirty = true
			global.customer_paid += 1
		
		#if player has food on them
		elif food == 1:
			customer_one.text = "customer (eating)"
			order_button.text = "make order"
			eating_one = true
			food -= 1
			eatingTimer.start()
		
		#if the customer has just ordered
		elif global.in_table_one:
			customer_one.text = "customer (order)"
			if eating_one == false:
				order = true

func on_switch():
	on = true

func off_switch():
	on = false

func buttons(enable):
	if enable == 0:
		customer_one.disabled = true
		customer_two.disabled = true
		order_button.disabled = true
		
	elif enable == 1 && global.in_table_one:
		customer_one.disabled = false
	if enable == 1 && global.in_table_two:
		customer_two.disabled = false

func refresh():
	customer_one_trigger = false
	customer_two_trigger = false


func _on_seating_timer_timeout():
	if global.in_table_one:
		customer_one.disabled = false
	if global.in_table_two:
		customer_two.disabled = false


func _on_order_timer_timeout():
	buttons(1)
	if order == true || order_two == true:
		order_button.disabled = false
		order_button.text = "order made!"
		food += 1
	
	#signals that customers orders have already been made
	if order == true:
		order = false
	if order_two == true:
		order_two = false

#when customers have finished eating
func _on_eating_timer_timeout():
		food_finished = true
		eating_one = false
		customer_one.text = "customer (finished)"

func _on_eating_2_timer_timeout():
		food_finished_two = true
		eating_two = false
		customer_two.text = "customer 2 (finished)"
