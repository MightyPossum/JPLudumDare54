extends RigidBody2D

@export var health = 20000
@export var damage = 600
@export var movementRange = 120
@export var Projectile : PackedScene
@export var currentFacing = 1
@export var boss_impact_particle_1 : PackedScene
@export var boss_impact_particle_2 : PackedScene
@export var boss_impact_particle_3 : PackedScene
var shootingTimer = 5
var timer = 0
var start_position
var playerAnimation
var player_in_range = true
var projectile_speed = 200
var projectile_lifetime = 3

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Enemy")
	start_position = position
	playerAnimation = get_node("Sprite2D")
	player = get_parent().get_parent().get_node("Player")
	playerAnimation.play("default")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	rotation = 0
	
	timer += delta
	if playerAnimation.frame == 0 and timer > 1:
		shoot()
		timer = 0
	
func shoot():
	var projectile = Projectile.instantiate()
	get_parent().get_parent().add_child(projectile)
	projectile.initialize_projectile(projectile_speed, currentFacing, damage, projectile_lifetime)
	projectile.transform = transform
	
func handle_hitting_something():
	for i in 1500:
		var particle_1 = boss_impact_particle_1.instantiate()
		var particle_2 = boss_impact_particle_2.instantiate()
		var particle_3 = boss_impact_particle_3.instantiate()
		get_parent().add_child(particle_1)
		get_parent().add_child(particle_2)
		get_parent().add_child(particle_3)
		particle_1.transform = transform
		particle_2.transform = transform
		particle_3.transform = transform
		#particle.position.x += 75
		#particle.position.y += 25
		particle_1.initialize(0.1, 4)
		particle_2.initialize(0.1, 4)
		particle_3.initialize(0.1, 4)

func receive_damage(damage_amount, _facing):
	health -= damage_amount
	get_node("HitAudio").play()
	if health <= 0:
		get_parent().get_node('Wall/TheEnd').queue_free()
		get_parent().get_node("Player").boss_dead()
		get_parent().get_node("Explosion").play()
		handle_hitting_something()
		queue_free()
		
		
func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		body.receive_damage(damage, currentFacing)
