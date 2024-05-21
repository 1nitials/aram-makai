extends Node

@onready var score: Label = $Label

func _process(delta):
	if global.customer_paid > 0:
		while(global.customer_paid > 0):
			global.score += 1
			score.text = "Score: %s" % global.score
			global.customer_paid -= 1
