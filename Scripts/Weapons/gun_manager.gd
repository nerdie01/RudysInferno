extends Node2D

@export var gun : Sprite2D
@export var gun_side_z_index_offset := 2

var orig_gun_zi : int
var orig_gun_scale : float

# Called when the node enters the scene tree for the first time.
func _ready():
	orig_gun_zi = gun.z_index
	orig_gun_scale = gun.scale.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().face_state == 0:
		gun.z_index = orig_gun_zi
		gun.scale.x = orig_gun_scale
	else:
		gun.z_index = orig_gun_zi