extends Area2D

var in_dialogue = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body:Node2D):
	if body.is_in_group("enemy"):
		var ds = body.get_parent()
		ds.dialogue_state = 1
		print(ds.dialogue_state)
		in_dialogue = true

func _on_body_exited(body:Node2D):
	if body.is_in_group("enemy"):
		var ds = body.get_parent()
		ds.dialogue_state = 0
		print(ds.dialogue_state)
		in_dialogue = false
