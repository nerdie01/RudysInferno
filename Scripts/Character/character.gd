extends CharacterBody2D

@export var speed := 150
@export var dash_multiplier := 1.75
@export var dash_time = 5
@export var lerp_intensity := 1000
@export var sugar_rush = 5
@export var crouch_speed_reduction = 0.75

var quad_vec : Vector2

var face_state = 0

func _physics_process(delta):
	var dir_vec = speed * crouch_speed_reduction * Input.get_vector("move_left", "move_right", "move_up", "move_down") if Input.is_action_pressed("sneak") else speed * Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if dir_vec:
		velocity = velocity.move_toward(dir_vec, delta * lerp_intensity)
		if Input.is_action_just_pressed("sprint") && sugar_rush:
			velocity = dash_multiplier * velocity
			velocity = velocity.move_toward(dir_vec, delta * dash_time)
			sugar_rush = sugar_rush - 1;
	else:
		velocity = velocity.move_toward(Vector2(0,0), delta * lerp_intensity)

	move_and_slide()

	var char_to_mouse_vec = get_local_mouse_position()
	var angle_to_character = atan2(-char_to_mouse_vec.y, char_to_mouse_vec.x)
	print(angle_to_character)
	if (-PI/8 <= angle_to_character && angle_to_character < PI/8):
		face_state = 1;
	if (PI/8 <= angle_to_character && angle_to_character < 5*PI/8):
		face_state = 2;
	if (angle_to_character >= 5*PI/8 || angle_to_character < -5*PI/8):
		face_state = -1;
	if (-5*PI/8 <= angle_to_character && angle_to_character < -PI/8):
		face_state = 0;