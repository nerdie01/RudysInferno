extends Node

@export var icon_scaling_time := 5.0
@export var icon_target_scale := Vector2.ONE
var icon : Sprite2D

var dialogue_state = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	icon = get_child(0).get_child(2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match dialogue_state:
		0:
			if icon.scale != Vector2.ZERO:
				icon.scale = lerp(icon.scale, Vector2.ZERO, icon_scaling_time * delta)
		1:
			if icon.scale != icon_target_scale:
				icon.scale = lerp(icon.scale, icon_target_scale, icon_scaling_time * delta)
			
