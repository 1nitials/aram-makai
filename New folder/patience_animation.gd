extends Sprite2D

var increment = 0

@onready var patienceTimer: Timer = $PatienceTimer
@onready var timerSprite: Sprite2D = $Fp19

func patience_start():
	patienceTimer.start()
	timerSprite.set_frame(0)

func _on_patience_timer_timeout():
	increment += 1
	if (increment <= 9):
		timerSprite.set_frame(increment)
		patienceTimer.start()
		print(increment)
	elif (increment <= 11):
		patienceTimer.start()
		print("Hurry!")
	else:
		print("Too late")
		global.lives -= 1
		get_parent().queue_free()
		global.total_customers -= 1
