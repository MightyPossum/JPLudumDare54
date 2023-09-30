extends RigidBody2D

var Health = 20
var Damage = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Enemy")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func receive_damage(damage_amount):
	Health -= damage_amount
	if Health <= 0:
		queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		body.receive_damage(Damage)
