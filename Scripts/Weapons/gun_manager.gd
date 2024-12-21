extends Node2D

@export var gun_side : Sprite2D
@export var gun_front : Sprite2D
@export var gun_back : Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match get_parent().face_state:
		-1:
			gun_side.visibility_changed = 
		0:
			print("mrrp meow mrreow")
		1:
			print(":3")
		2:
			print("mrreow")
