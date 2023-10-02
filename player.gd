extends CharacterBody2D


@export var Speed = 200
@export var JumpTranslation = Speed * 0.9
@export var Gravity = 40
@export var JumpVelocity = 850#420
@export var damageVelocity = 0
@export var Projectile : PackedScene
@export var health_pack : PackedScene
@export var attack_speed : PackedScene
@export var player_impact_particle : PackedScene
var GLOBAL_VALUES

var health = 400
var damaged = false
var timer = 0
var shootingTimer = 0.2
var projectile_speed = 1000
var damage = 100
var projectile_lifetime = 0.3

var playerAnimation
var door
var camera

var currentFacing = 1
var enemy_facing = 0
var damagedTimer = 0.25
var damagedtime = 0
var pushed = false
var coins_collected = 0
var keys_collected = 0
var in_doorway = false
var i_am_dead = false

var exit_scaling_count = 0
var exit_scaling_time = 1
var exit = false
var death_counter = 0
var death_time = 2.5

var upgrade1_aquired = false
var upgrade2_aquired = false

# Called when the node enters the scene tree for the first time.
func _ready():
	GLOBAL_VALUES = get_node("/root/GlobalValues")
	
	health = GLOBAL_VALUES.PLAYER_MAX_HEALTH
	damage = GLOBAL_VALUES.PLAYER_DAMAGE
	projectile_speed = GLOBAL_VALUES.PLAYER_SHOOTING_SPD
	shootingTimer = GLOBAL_VALUES.PLAYER_SHOOTING_INTERVAL
	coins_collected = GLOBAL_VALUES.PLAYER_COINS
	projectile_lifetime = GLOBAL_VALUES.PLAYER_SHOOTING_LIFETIME
	
	check_upgrade_level()
	
	add_to_group("Player")
	playerAnimation = get_node("Sprite2D")
	door = get_parent().get_node("door")
	camera = get_parent().get_node("Camera2D")

func boss_dead():
	GLOBAL_VALUES.CURRENT_LEVEL = 4
	
func check_upgrade_level():
	match GLOBAL_VALUES.CURRENT_LEVEL:
		1:
			upgrade1_aquired = GLOBAL_VALUES.LEVEL_1_1_AQUIRED
			upgrade2_aquired = GLOBAL_VALUES.LEVEL_1_2_AQUIRED
		2:
			upgrade1_aquired = GLOBAL_VALUES.LEVEL_2_1_AQUIRED
			upgrade2_aquired = GLOBAL_VALUES.LEVEL_2_2_AQUIRED
	
func handle_hitting_something():
	for i in 1000:
		var particle = player_impact_particle.instantiate()
		get_parent().add_child(particle)
		particle.transform = transform
		particle.initialize(0.1, 4)

func shoot():
	var projectile = Projectile.instantiate()
	get_parent().add_child(projectile)
	projectile.initialize_projectile(projectile_speed, currentFacing, damage, projectile_lifetime)
	projectile.transform = transform
	
	var randomizer = RandomNumberGenerator.new()
	randomizer.randomize()
	var shot_adjustement = randomizer.randf_range(-10,10)
	
	projectile.position.y += shot_adjustement
	projectile.handle_animation(currentFacing)
	timer = 0

func receive_damage(damage_amount, facing):
	damaged = true
	enemy_facing = facing
	handle_animation("damage", enemy_facing)
	
	damageVelocity = damage_amount
	
	health -= damage_amount
	DisplayServer.window_set_title('Remaining Health: ' + str(health))
	if health <= 0:
		DisplayServer.window_set_title('You Dead!')
		i_am_dead = true
		get_node("DeathScream").play()
		handle_hitting_something()
		#visible = false
		GLOBAL_VALUES.ALLOW_MOVEMENT = false
		get_node("CollisionShape2D").queue_free()
		
		
func handle_animation(animation, facing):
	if facing == 1:
		playerAnimation.play(animation + "Right")
	elif facing == -1:
		playerAnimation.play(animation + "Left")

func _physics_process(delta):
	velocity.y += Gravity
	
	
	if not damaged and GLOBAL_VALUES.ALLOW_MOVEMENT:
		if is_on_floor():
			velocity.x = Input.get_axis("Input Left", "Input Right") * Speed
			if Input.is_action_just_pressed("Jump"):
				velocity.y -= JumpVelocity
				get_node("JumpSound").play()
		else:
			velocity.x = Input.get_axis("Input Left", "Input Right") * JumpTranslation
		
		timer += delta
		if Input.is_action_pressed("Shoot"):
			
			if timer >= shootingTimer:
				shoot()

	
		if is_on_floor(): 
			if velocity.x == 0:
				handle_animation("idle",currentFacing)
				if Input.is_action_pressed("Down"):
					handle_animation("lookDown", currentFacing)
			elif velocity.x != 0:
				handle_animation("run",currentFacing)
		else:
			if velocity.y < 0:
				handle_animation("jump",currentFacing)
			else:
				handle_animation("fall",currentFacing)
		
		if velocity.x < 0:
			currentFacing = -1
		elif velocity.x > 0:
			currentFacing = 1
	
	if damaged:
		if not pushed:
			get_node("HitAudio").play()
			velocity.x = enemy_facing * damageVelocity
			pushed = true
			
		damagedtime += delta
		if damagedtime >= damagedTimer:
			damaged = false
			pushed = false
			damagedtime = 0

	if i_am_dead:
		GLOBAL_VALUES.GAME_FALLING = true
		death_counter += delta
		if death_counter >= death_time:
			get_tree().change_scene_to_file("res://MainScene.tscn")
		
		
	move_and_slide()
	
	if Input.is_action_pressed("Shoot") and in_doorway:
		exit = true
		
		get_window().position.x = position.x
		get_window().position.y = position.y
		
	if exit:
		exit_scaling_count += delta * 2
		
		get_window().size = Vector2(get_window().size.x - (exit_scaling_count*2),get_window().size.y - exit_scaling_count)
		#get_window().position = Vector2(get_window().size.x - (exit_scaling_count),get_window().size.y - exit_scaling_count)
		
		if get_window().size.x <= 64:
			get_window().position.x -= 10
		camera.position = get_window().position
		
		if get_window().position.x < -500:
			load_next_level()
	
	if GLOBAL_VALUES.GAME_FALLING:
		Gravity = 5
	else:
		Gravity = 40
		
	if GLOBAL_VALUES.GAME_FALLING && is_on_floor():
		GLOBAL_VALUES.GAME_FALLING = false

func load_next_level():
	match GLOBAL_VALUES.CURRENT_LEVEL:
		1:
			GLOBAL_VALUES.LEVEL_1_1_AQUIRED = upgrade1_aquired
			GLOBAL_VALUES.LEVEL_1_2_AQUIRED = upgrade2_aquired
			if upgrade1_aquired:
				GLOBAL_VALUES.PLAYER_MAX_HEALTH += 400
			if upgrade2_aquired:
				GLOBAL_VALUES.PLAYER_SHOOTING_SPD += 400
				GLOBAL_VALUES.PLAYER_SHOOTING_INTERVAL -= 0.02
			GLOBAL_VALUES.CURRENT_LEVEL = 2
			GLOBAL_VALUES.HIGHEST_LEVEL = 1
			get_tree().change_scene_to_file("res://MainScene_2.tscn")
		2:
			GLOBAL_VALUES.CURRENT_LEVEL = 3
			GLOBAL_VALUES.HIGHEST_LEVEL = 2
			if upgrade1_aquired:
				GLOBAL_VALUES.PLAYER_MAX_HEALTH += 400
			if upgrade2_aquired:
				GLOBAL_VALUES.PLAYER_SHOOTING_SPD += 400
				GLOBAL_VALUES.PLAYER_SHOOTING_INTERVAL -= 0.02
			GLOBAL_VALUES.LEVEL_2_1_AQUIRED = upgrade1_aquired
			GLOBAL_VALUES.LEVEL_2_2_AQUIRED = upgrade2_aquired
			get_tree().change_scene_to_file("res://BossScene_1.tscn")

func prep_and_save_level(scene_name, current_level):
	get_tree().change_scene_to_file("res://+ " + scene_name + ".tscn")
	
func spawn_upgrade(type_number):
	var upgrade
	if type_number == 1 && not upgrade1_aquired:
		upgrade = health_pack.instantiate()
	elif type_number == 2 && not upgrade2_aquired:
		upgrade = attack_speed.instantiate()
		
	get_parent().add_child(upgrade)
	var myTransform = position
	myTransform.y -= 40
	upgrade.position = myTransform
	

func collect_coin(value):
	coins_collected += value
	if coins_collected == 1:
		if not upgrade2_aquired:
			DisplayServer.window_set_title('Coins: 1. "Why are you picking up every dirty thing you see?"' )
	elif coins_collected == 2:
		if not upgrade2_aquired:
			DisplayServer.window_set_title('Coins: 2. "Wow, You\'ve got a pair!!"')
	elif coins_collected == 3:
		if upgrade1_aquired and not upgrade2_aquired:
			DisplayServer.window_set_title('Coins: 3. "Oh, so the first price was not enough?"' )
		elif upgrade2_aquired:
			DisplayServer.window_set_title('Coins: 3. "Move along!"' )
		else:
			DisplayServer.window_set_title('Coins: 3. Fine! Find two more and I\'ll give you a prize')
	elif coins_collected == 4:
		if not upgrade2_aquired:
			DisplayServer.window_set_title('Coins: 4. "Hah, bet you can\'t find the last one!"' )
	if coins_collected == 5:
		if not upgrade2_aquired:
			DisplayServer.window_set_title('Coins: 5. "Well... shit.. Sure, I\'m a ##### of my word, here\'s to your health"')
		else:
			DisplayServer.window_set_title('Coins: 5. "I told you, no more prizes...."')
		spawn_upgrade(1)
	elif coins_collected == 6:
		DisplayServer.window_set_title('Coins: 6. "Why are you picking up every dirty thing you see?"' )
		spawn_upgrade(2)

func collect_key(value):
	keys_collected += value
	DisplayServer.window_set_title("Wow, you found the key... Your mom would be impressed")

func is_in_doorway(boolean_door):
	in_doorway = boolean_door

func _on_area_2d_body_entered(body):
	if body.is_in_group("Enemy"):
		body._can_see_player(position.x)

func upgrade_attack_speed(attack_speed, attack_timer):
	projectile_speed += attack_speed
	shootingTimer -= attack_timer
