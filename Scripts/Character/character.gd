extends CharacterBody2D

@export var speed := 150.0
@export var dash_multiplier := 1.75
@export var dash_time := 1

@export var light_atk_boost := 1.25
@export var light_atk_boost_time := 5.0
@export var light_atk_time = 1.0

@export var heavy_atk_boost := -0.25
@export var heavy_atk_boost_time := 5.0
@export var heavy_atk_time = 1.0

@export var atk_col_shape : CollisionShape2D
@export var atk_thres := 150
@export var knockback := 1

@export var lerp_intensity := 1000.0
@export var n_dash = 5
@export var crouch_speed_reduction = 0.75
@export var light_hitbox_params = [Vector2(20,15), Vector2(10,0)]
@export var heavy_hitbox_params = [Vector2(32,32), Vector2(16,0)]

var angle_to_character : float
var face_state : int = 0
var t0 : float
var is_atking : bool = false

func _ready():
	pass

func _physics_process(delta):
	var dir_vec = speed * crouch_speed_reduction * Input.get_vector("move_left", "move_right", "move_up", "move_down") if Input.is_action_pressed("sneak") else speed * Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = velocity.move_toward(dir_vec, delta * lerp_intensity)
	if Input.is_action_just_pressed("sprint") && n_dash && dir_vec:
		velocity = dash_multiplier * velocity
		velocity = velocity.move_toward(dir_vec, delta * dash_time)
		n_dash = n_dash - 1;

	move_and_slide()

	var char_to_mouse_vec = get_local_mouse_position()
	
	# code to attack
	# get difference between initial and final mouse press times to determine light or heavy atk

	if Input.is_action_just_pressed("attack"):
		t0 = Time.get_ticks_msec()
	if Input.is_action_just_released("attack"):
		# if mouse was pressed for long enough, do heavy attack
		var dt = Time.get_ticks_msec() - t0
		if !is_atking:
			if dt < atk_thres:
				velocity = light_atk_boost * char_to_mouse_vec.normalized() + velocity
				velocity = velocity.move_toward(dir_vec, delta * light_atk_boost_time)
				print("Light atk at t = ", t0, ", delta t = ", dt, ")")
				await do_attack(light_hitbox_params, light_atk_time)
			else:
				velocity = heavy_atk_boost * char_to_mouse_vec.normalized() + velocity
				velocity = velocity.move_toward(dir_vec, delta * heavy_atk_boost_time)
				print("Heavy atk at t = ", t0, ", delta t = ", dt, ")")
				await do_attack(heavy_hitbox_params, heavy_atk_time)


	angle_to_character = atan2(-char_to_mouse_vec.y, char_to_mouse_vec.x)

	if (-PI/8 <= angle_to_character && angle_to_character < PI/8):
		face_state = 1;
	if (PI/8 <= angle_to_character && angle_to_character < 5*PI/8):
		face_state = 2;
	if (angle_to_character >= 5*PI/8 || angle_to_character < -5*PI/8):
		face_state = -1;
	if (-5*PI/8 <= angle_to_character && angle_to_character < -PI/8):
		face_state = 0;

func do_attack(hitbox, time):
	is_atking = true

	atk_col_shape.shape.extents = hitbox[0]
	atk_col_shape.position = Vector2(
		hitbox[1].x * cos(angle_to_character) - hitbox[1].y * sin(angle_to_character),
		-hitbox[1].x * sin(angle_to_character) - hitbox[1].y * cos(angle_to_character))
	atk_col_shape.rotation =  -angle_to_character

	await get_tree().create_timer(time).timeout

	atk_col_shape.shape.extents = Vector2.ZERO
	is_atking = false

func _on_hit_box_body_entered(body):
	if body.is_in_group("enemy"):
		body.apply_central_impulse(knockback * get_local_mouse_position())