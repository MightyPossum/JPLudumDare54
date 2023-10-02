extends Node2D

var coin_value = 1
var coin_animation
@export var coin_impact_particle : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	coin_animation = get_node("AnimatedSprite2D")
	coin_animation.play("default")

func handle_hitting_something():
	for i in 30:
		var particle = coin_impact_particle.instantiate()
		get_parent().get_parent().add_child(particle)
		particle.transform = transform
		particle.initialize(0.01, 2)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group('Player'):
		get_parent().get_parent().get_node("CoinAudio").play()
		body.collect_coin(coin_value)
		handle_hitting_something()
		queue_free()
