extends CanvasLayer

var Done := false

func _ready():
	visible = false




func _process(delta):
	if not Done:
		if $"../animation_of_character_normal".animation == "player_death":
			var screen_center = get_viewport().get_visible_rect().size / 2
			$AnimatedSprite2D.position = screen_center
			$AnimatedSprite2D.play("game_over_normal")
			$AnimatedSprite2D.scale = Vector2(4, 4)
			visible = true
			Done = true
		

func _input(event: InputEvent) -> void:
		if event.is_action_pressed("restart"):
			visible = false
			Done = false

			
	
	
