extends CharacterBody2D

@export var speed = 130
@export var Coyote_Time : float = 0.1
@onready var sprite = $animation_of_character_distorted
var jump_velocity = -300
var Jump_Available : bool = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready() -> void:
	position = PositionTracking.player_position
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("distortion"):
		PositionTracking.player_position = $".".position
		get_tree().change_scene_to_file("res://scenes/first_normal_scene/first_location_normal.tscn")
		

func _physics_process(delta):
	var direction = Input.get_axis("left","right")
	if not is_on_floor():
		if Jump_Available:
			get_tree().create_timer(Coyote_Time).timeout.connect(Coyote_Timeout)
		velocity.y += gravity * delta
	else:
		Jump_Available = true
		
		
	
		
	if Input.is_action_just_pressed("jump") and Jump_Available:
		velocity.y = jump_velocity
		Jump_Available = false
		
	
	
	
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true
	
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	move_and_slide()
func Coyote_Timeout():
	Jump_Available = false
	
