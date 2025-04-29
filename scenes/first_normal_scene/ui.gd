extends CanvasLayer

@onready var timer_label = $TimerLabel
@onready var game_timer = $GameTimer

var time: int = 120
var counting_up := false 

func _ready() -> void:
	update_timer_label()
	game_timer.wait_time = 1.0
	game_timer.autostart = true
	game_timer.one_shot = false
	game_timer.start()

func _on_game_timer_timeout() -> void:
	if counting_up:
		time += 1
	else:
		time -= 1
	
	#when timer reaches 0, for death
	if time < 0:
		time = 0
		game_timer.stop() #for now it just stops
		
	
	update_timer_label()

func update_timer_label() -> void:
	var min = time / 60
	var sec = time % 60
	timer_label.text = "%02d:%02d" % [min, sec]

func _input(event):
	if event is InputEventKey and event.keycode == KEY_ENTER and event.pressed:
		time += 30  
		update_timer_label() 
