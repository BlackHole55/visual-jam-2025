extends CanvasLayer

@onready var timer_label = $TimerLabel
@onready var game_timer = $GameTimer

var counting_up := false 

func _ready() -> void:
	update_timer_label()
	game_timer.wait_time = 1.0
	game_timer.autostart = true
	game_timer.one_shot = false
	game_timer.start()

func _on_game_timer_timeout() -> void:
	if counting_up:
		Variables.time += 1
	else:
		Variables.time -= 1
	
	#when timer reaches 0, for death
	if Variables.time < 0:
		Variables.time = 0
		game_timer.stop() #for now it just stops
		Variables.is_Dead = true
	update_timer_label()

func update_timer_label() -> void:
	var min = Variables.time / 60
	var sec = Variables.time % 60
	timer_label.text = "%02d:%02d" % [min, sec]
