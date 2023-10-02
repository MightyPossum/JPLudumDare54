extends RigidBody2D

@export var health = 400
@export var damage = 100
@export var movementRange = 120
@export var Projectile : PackedScene
@export var currentFacing = 1
var shootingTimer = 1.2
var timer = 0
var start_position
var playerAnimation
var player_in_range = false
var projectile_speed = 200
var projectile_lifetime = 3

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Enemy")
	start_position = position
	playerAnimation = get_node("Sprite2D")
	handle_animation("walk")
	player = get_parent().get_parent().get_node("Player")

	var randomizer = RandomNumberGenerator.new()
	randomizer.randomize()
	currentFacing = randomizer.randf_range(-1,1)
	if currentFacing >= 0:
		currentFacing = 1
	elif currentFacing < 0:
		currentFacing = -1
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	rotation = 0
	timer += delta
	if timer >= shootingTimer and player_in_range:
		shoot()
		timer = 0
		
	if position.x < start_position.x + (movementRange + 10) && currentFacing == 1:
		position.x += 1
		if position.x >= start_position.x + movementRange:
			currentFacing = -currentFacing
			handle_animation("walk")
	elif position.x > start_position.x - (movementRange + 10) && currentFacing == -1:
		position.x -= 1
		if position.x <= start_position.x - movementRange:
			currentFacing = -currentFacing
			handle_animation("walk")
			
	can_see_player(player.position)
			
			
func handle_animation(animation):
	if currentFacing == 1:
		playerAnimation.play(animation + "Right")
	elif currentFacing == -1:
		playerAnimation.play(animation + "Left")
	
func shoot():
	var projectile = Projectile.instantiate()
	get_parent().get_parent().add_child(projectile)
	projectile.initialize_projectile(projectile_speed, currentFacing, damage, projectile_lifetime)
	projectile.transform = transform

func receive_damage(damage_amount, _facing):
	health -= damage_amount
	get_node("HitAudio").play()
	
	if health <= 0:
		get_parent().get_parent().get_node('EnemyDeath').play()
		queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("Wall") or body.is_in_group("Enemy"):
		currentFacing = -currentFacing
		handle_animation("walk")
	if body.is_in_group("Player"):
		body.receive_damage(damage, currentFacing)
		
func can_see_player(player_position):
	var enemy_range = position.x + (currentFacing * 350)
	
	if player_position.x >= position.x and player_position.x <= enemy_range and currentFacing > 0 and player.position.y <= position.y + 50 and player.position.y >= position.y - 50:
		player_in_range = true
	elif player_position.x <= position.x and player_position.x >= enemy_range and currentFacing < 0 and player.position.y <= position.y + 50 and player.position.y >= position.y - 50:
		player_in_range = true
	else:
		player_in_range = false
