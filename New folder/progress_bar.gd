extends Node

@onready var progressTimer: Timer = $ProgressTimer
@onready var progressBar: TextureProgressBar = $TextureProgressBar

func progress_start():
	progressTimer.start()


func _on_progress_timer_timeout():
	progressBar.value += 0.5
