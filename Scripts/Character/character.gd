extends CharacterBody2D

@export var speed := 150.0
@export var dash_multiplier := 1.75
@export var dash_time := 1
@export var light_attack_boost := 1.25
@export var light_attack_boost_time := 5.0
@export var heavy_attack_boost := -0.25
@export var heavy_attack_boost_time := 5.0
@export var light_atk_thres := 100
@export var lerp_intensity := 1000.0
@export var sugar_rush = 5.0
@export var crouch_speed_reduction = 0.75

var angle_to_character : float

var face_state = 0
var t0

func _physics_process(delta):
	var dir_vec = speed * crouch_speed_reduction * Input.get_vector("move_left", "move_right", "move_up", "move_down") if Input.is_action_pressed("sneak") else speed * Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = velocity.move_toward(dir_vec, delta * lerp_intensity)
	if Input.is_action_just_pressed("sprint") && sugar_rush && dir_vec:
		velocity = dash_multiplier * velocity
		velocity = velocity.move_toward(dir_vec, delta * dash_time)
		sugar_rush = sugar_rush - 1;

	move_and_slide()

	var char_to_mouse_vec = get_local_mouse_position()
	
	# code to attack
	# get difference between initial and final mouse press times to determine light or heavy attack

	if Input.is_action_just_pressed("attack"):
		t0 = Time.get_ticks_msec()
		print(t0)
	if Input.is_action_just_released("attack"):
		print("hi")
		# if mouse was pressed for long enough, do heavy attack
		var dt = Time.get_ticks_msec() - t0
		if dt < light_atk_thres:
			velocity = light_attack_boost * char_to_mouse_vec.normalized() + velocity
			velocity = velocity.move_toward(dir_vec, delta * light_attack_boost_time)
			print("Light attack at t = ", t0, ", delta t = ", dt, ")")
		else:
			velocity = heavy_attack_boost * char_to_mouse_vec.normalized() + velocity
			velocity = velocity.move_toward(dir_vec, delta * heavy_attack_boost_time)
			print("Heavy attack at t = ", t0, ", delta t = ", dt, ")")

	angle_to_character = atan2(-char_to_mouse_vec.y, char_to_mouse_vec.x)

	if (-PI/8 <= angle_to_character && angle_to_character < PI/8):
		face_state = 1;
	if (PI/8 <= angle_to_character && angle_to_character < 5*PI/8):
		face_state = 2;
	if (angle_to_character >= 5*PI/8 || angle_to_character < -5*PI/8):
		face_state = -1;
	if (-5*PI/8 <= angle_to_character && angle_to_character < -PI/8):
		face_state = 0;