extends Node2D

@onready var path = preload("res://customer/path_placeholder.tscn")

func _ready():
	var tempPath = path.instantiate()
	add_child(tempPath)
	global.total_customers += 1
	print(global.total_customers)

func _on_timer_timeout():
	if global.total_customers < 2:
		var tempPath = path.instantiate()
		add_child(tempPath)
		global.total_customers += 1
		print(global.total_customers)
