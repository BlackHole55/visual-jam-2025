extends CharacterBody2D

@export var speed = 130
@onready var sprite = $animation_of_character_normal
var jump_velocity = -300
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	position = PositionTracking.player_position

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("distortion"):
		PositionTracking.player_position = $".".position
		print(PositionTracking.player_position)
		get_tree().change_scene_to_file("res://scenes/first_distorted_scene/first_location_distorted.tscn")
		

func _physics_process(delta):
	var direction = Input.get_axis("left","right")
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		
	
	
	
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true
	
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	move_and_slide()

	
	
