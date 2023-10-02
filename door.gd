extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		if body.keys_collected > 0:
			body.is_in_doorway(true)
			DisplayServer.window_set_title("Have you tried hitting the Spacebar, numbty?")
		else:
			DisplayServer.window_set_title("Stop wasting my time, find the key...")


func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		body.is_in_doorway(false)
