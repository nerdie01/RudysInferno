extends Camera2D

@export var lerp_speed = 0.05
@export var target : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = lerp(self.position, target.position, lerp_speed)
