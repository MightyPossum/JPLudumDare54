extends Node2D

var key_value = 1
@export var key_impact_particle : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func handle_hitting_something():
	for i in 30:
		var particle = key_impact_particle.instantiate()
		get_parent().get_parent().add_child(particle)
		particle.transform = transform
		particle.initialize(0.01, 2)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group('Player'):
		body.collect_key(key_value)
		get_parent().get_node("KeyAudio").play()
		handle_hitting_something()
		queue_free()
