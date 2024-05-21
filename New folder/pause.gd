extends Control

@onready var main = $"../../Path2D/PathFollow2D"



func _on_play_pressed():
	main.pauseMenu()


func _on_quit_pressed():
	main.pauseMenu()
	global.reset()
	get_tree().change_scene_to_file("res://menu.tscn")
