extends Node


func _ready():
	global.lives = 3

func _physics_process(delta):
	
	if global.lives == 3:
		$Hearts.set_frame(0)
		$Hearts2.set_frame(0)
		$Hearts3.set_frame(0)
	if global.lives == 2:
		$Hearts.set_frame(1)
		$Hearts2.set_frame(0)
		$Hearts3.set_frame(0)
	if global.lives == 1:
		$Hearts.set_frame(1)
		$Hearts2.set_frame(1)
		$Hearts3.set_frame(0)
	if global.lives == 0:
		$Hearts.set_frame(1)
		$Hearts2.set_frame(1)
		$Hearts3.set_frame(1)
		
