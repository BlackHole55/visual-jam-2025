extends CharacterBody2D

@export var Jump_Buffer_Time: float = 0.1
@export var speed = 130
@export var Coyote_Time : float = 0.1
@onready var sprite = $animation_of_character_normal

var jump_velocity = -300
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var Jump_Available : bool = true
var Jump_Buffer:bool = false
var SpawnPoint = Vector2.ZERO

#Instantly replace player with global variable position (defaul zero vector, but after 
#distortion input it replaces zero vector with coordinates on another dimension)
#also checks if character after swap is in the wall, it changes position to spawnpoint!!
func _ready():
	position = PositionTracking.player_position
	
	await get_tree().process_frame 
	if is_stuck():
		position = SpawnPoint

#switches the realms
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("distortion"):
		PositionTracking.player_position = $".".position
		get_tree().change_scene_to_file("res://scenes/first_distorted_scene/first_location_distorted.tscn")
	
	#sprint
	if event.is_action_pressed("sprint"):
		speed = 180
		
	if event.is_action_released("sprint"):
		speed = 130


func _physics_process(delta):
	#gets direction (either negative either positive number)
	var direction = Input.get_axis("left","right")
	#Check if character is on floor, else you can jump
	#also has jump_buffer and coyote_time feature;
	if not is_on_floor():
		if Jump_Available:
			get_tree().create_timer(Coyote_Time).timeout.connect(Coyote_Timeout)
		velocity.y += gravity * delta
	else:
		Jump_Available = true
		if Jump_Buffer:
			Jump()
			Jump_Buffer = false
		
	#Jump function, which tracks when the button was pressed
	if Input.is_action_just_pressed("jump"):
		if Jump_Available:
			Jump()
		else:
			Jump_Buffer = true
			get_tree().create_timer(Jump_Buffer_Time).timeout.connect(on_jump_buffer_timeout)
		
	
	
	#if direction is negative, it flips the character, so it looks to the left
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true
	
	#If direction has a value, it means player pressed move key
	#so this function moves character in game
	if direction:
		sprite.animation = "player_move"
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		sprite.animation = "idle_normal"
		
	#last function, which glue everything together.
	move_and_slide()
func Coyote_Timeout():
	Jump_Available = false
	

func Jump():
	velocity.y = jump_velocity
	Jump_Available = false

func on_jump_buffer_timeout():
	Jump_Buffer = false
	
func is_stuck() -> bool:
	var collision = move_and_collide(Vector2.ZERO)
	return collision != null


func _on_area_2d_normal_area_entered(area: Area2D) -> void:
	if area.is_in_group("pickable_items"):
		Variables.is_Pressed = true
		
