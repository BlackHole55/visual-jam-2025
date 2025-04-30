extends CanvasLayer

var Done := false

func _ready():
	visible = false




func _process(delta):
	if Variables.is_Dead:
		var current_scene = get_tree().current_scene
		if current_scene.name == "first_location_normal":
			$"../animation_of_character_normal".animation = "player_death"
		elif current_scene.name == "first_location_distorted":
			$"../animation_of_character_distorted".animation = "distorted_death"
		var screen_center = get_viewport().get_visible_rect().size / 2
		$AnimatedSprite2D.position = screen_center
		$AnimatedSprite2D.play("game_over_normal")
		$AnimatedSprite2D.scale = Vector2(4, 4)
		visible = true
		
		

func _input(event: InputEvent) -> void:
		if event.is_action_pressed("restart"):
			visible = false
			Done = false

			
	
	
