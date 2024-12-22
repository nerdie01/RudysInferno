extends RigidBody2D

@export var k : float = 50.0

func _physics_process(delta):
	apply_central_force(-linear_velocity * k)
