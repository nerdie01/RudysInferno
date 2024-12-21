class_name Hitbox
extends Area2D

# Damage dealt by hitbox
export var damage: int := 10

func _init() -> void:
    # Init collision layers
    collision_layer = 2
    collision_mask = 0
