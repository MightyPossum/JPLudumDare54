extends Area2D

var speed = 0
var damage = 100
var projectileAnimation
var projectile_direction
var lifetime = 0.5
var lifetime_count = 0
@export var player_impact_particle : PackedScene
@export var enemy_impact_particle : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group('Projectile')
	projectileAnimation = get_node("Sprite2D")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _physics_process(delta):
	position += transform.x * speed * delta
	
	lifetime_count += delta
	if lifetime_count >= lifetime:
		queue_free()
	
func initialize_projectile(_speed, _direction, _damage, _lifetime):
	speed = _speed * _direction
	projectile_direction = _direction
	damage = _damage
	lifetime = _lifetime
	

func handle_animation(currentFacing):
	projectile_direction = currentFacing
	if currentFacing == 1:
		projectileAnimation.play('shootRight')
	elif currentFacing == -1:
		projectileAnimation.play('shootLeft')

func handle_hitting_something(body, damage_dealt, object_impact_particle, lifetime, particle_speed):
	var particle_amount = 30
	
	if body.health <= damage_dealt:
		particle_amount = 300
	else:
		particle_amount = 30
	for i in particle_amount:
		var particle = object_impact_particle.instantiate()
		get_parent().add_child(particle)
		particle.transform = body.transform
		particle.initialize(lifetime, particle_speed)
		
	body.receive_damage(damage_dealt, projectile_direction)

func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		handle_hitting_something(body, damage, enemy_impact_particle, 0.1, 10)
	if body.is_in_group("Player"):
		handle_hitting_something(body, damage, player_impact_particle, 0.1, 10)
		
	queue_free()
