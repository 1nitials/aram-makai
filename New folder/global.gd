extends Node2D

var is_dragging = false
var is_mouse_busy = false
var dragged_objects = 0

var is_forwards = true
var is_free = true
var customer_one_trigger = false
var customer_two_trigger = false

var in_table_one = false
var in_table_two = false
var table_one_dirty = false
var table_two_dirty = false

var counter = 0
var counter_2 = 0

var total_customers = 0

var lives = 3

var paused = false
var score = 0

var customer_paid = 0

func reset():
	counter = 0
	counter_2 = 0
	total_customers = 0
	lives = 3
	
	score = 0
	
	is_dragging = false
	is_mouse_busy = false
	dragged_objects = 0
	is_forwards = true
	is_free = true
	customer_one_trigger = false
	customer_two_trigger = false

	in_table_one = false
	in_table_two = false
	table_one_dirty = false
	table_two_dirty = false
