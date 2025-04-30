extends CharacterBody2D

@export var Jump_Buffer_Time: float = 0.1
@export var speed = 130
@export var Coyote_Time : float = 0.1
@onready var sprite = $animation_of_character_distorted

var jump_velocity = -300
var Jump_Buffer:bool = false
var Jump_Available : bool = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#Instantly replace player with global variable position (defaul zero vector, but after 
#distortion input it replaces zero vector with coordinates on another dimension)
#also checks if character after swap is in the wall, it changes position to spawnpoint!!

func _ready():
	if not Variables.SwitchRealms:
		position = PositionTracking.player_position
		$"../AudioStreamPlayer2D".play()
	else:
		position = Variables.SpawnPoint
		Variables.SwitchRealms = false
	await get_tree().process_frame 
	if is_stuck():
		sprite.animation = "distorted_death"
		Variables.is_Dead = true


#switches the realms
func _input(event: InputEvent) -> void:
	if not Variables.is_Dead:
		if event.is_action_pressed("distortion"):
			PositionTracking.player_position = $".".position
			get_tree().change_scene_to_file("res://scenes/first_normal_scene/first_location_normal.tscn")
	
	#sprint
	if event.is_action_pressed("sprint"):
		speed = 180
		
	if event.is_action_released("sprint"):
		speed = 130
	
	if event.is_action_pressed("restart"):
		Variables.is_Dead = false
		Variables.time = 30
		Variables.picked_items.clear()
		Variables.SwitchRealms = true
		get_tree().reload_current_scene()
		
		
func _physics_process(delta):
	if not Variables.is_Dead:
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
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)

		if not is_on_floor():
			if velocity.y < 0:
				sprite.animation = "distorted_jumping"  
			else:
				sprite.animation = "distorted_falling"
			pass
		else:
			if direction:
				sprite.animation = "distorted_running"
				sprite.play("distorted_running")
			else:
				sprite.animation = "distorted_idle" 
				sprite.play("distorted_idle")
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
