extends CharacterBody2D


@export var Speed = 200
@export var JumpTranslation = Speed * 0.9
@export var Gravity = 9.81
@export var JumpVelocity = 500
@export var Projectile : PackedScene

var Health = 100

var CurrentFacing = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func shoot():
	var projectile = Projectile.instantiate()
	get_parent().add_child(projectile)
	projectile.set_speed(CurrentFacing * projectile.Speed)
	projectile.transform = transform

func receive_damage(damage_amount):
	Health -= damage_amount
	print(Health)
	if Health <= 0:
		queue_free()

func _physics_process(_delta):
	velocity.y += Gravity
	
	if is_on_floor():
		velocity.x = Input.get_axis("Input Left", "Input Right") * Speed
		if Input.is_action_just_released("Jump"):
			velocity.y -= JumpVelocity
	else:
		velocity.x = Input.get_axis("Input Left", "Input Right") * JumpTranslation
		
	if Input.is_action_pressed("Shoot"):
		shoot()
		
	if velocity.x < 0:
		CurrentFacing = -1
	elif velocity.x > 0:
		CurrentFacing = 1

	
	move_and_slide()
	
