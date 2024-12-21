class_name Hurtbox
extends Area2D


func _init() -> void:
    # Init collision layers
    collision_layer = 0;
    collision_mask = 0;

funct _ready() -> void:
    # Did collision happen
    connect("area_entered", self, "_on_area_entered")

func _on_area_entered(hitbox: hitbox) -> void:
    #If collision happened do damage
    if hitbox == null:
        return
    
    if owner.has_method("take_damage")
        owner.take_damage(hitbox.damage)
