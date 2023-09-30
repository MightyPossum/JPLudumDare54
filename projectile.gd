extends Area2D

var Speed = 750
var Damage = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group('Projectile')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _physics_process(delta):
	position += transform.x * Speed * delta
	
func set_speed(speed):
	Speed = speed


func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		body.receive_damage(Damage)
		
	queue_free()
