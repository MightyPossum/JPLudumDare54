extends Node2D

var direction
var speed
var lifetime = 0.0
var x_direction
var y_direction
var lifeTimeCounter = 0
# Called when the node enters the scene tree for the first time.

func _ready():
	var rand_x = RandomNumberGenerator.new()
	var seed_x = RandomNumberGenerator.new().randf_range(-10000, 10000)
	rand_x.seed = seed_x
	rand_x.randomize()
	x_direction = rand_x.randf_range(-1,1)
	
	
	var rand_y = RandomNumberGenerator.new()
	var seed_y = RandomNumberGenerator.new().randf_range(-10000, 10000)
	rand_y.seed = seed_y
	rand_y.randomize()
	y_direction = rand_y.randf_range(-1,1)


func _physics_process(delta):
	
	position += transform.x * speed * x_direction
	position += transform.y * speed * y_direction
	
	lifeTimeCounter += delta
	if lifeTimeCounter >= lifetime:
		queue_free()
	
	
	

func initialize(_lifetime, _speed):
	speed = _speed
	lifetime = _lifetime
	
	var rand_speed = RandomNumberGenerator.new()
	var seed_speed = RandomNumberGenerator.new().randf_range(-10000, 10000)
	rand_speed.seed = seed_speed
	rand_speed.randomize()
	speed = rand_speed.randf_range(speed - speed / 4, speed + speed / 4)
	
	var rand_lifetime = RandomNumberGenerator.new()
	var seed_lifetime = RandomNumberGenerator.new().randf_range(-10000, 10000)
	rand_lifetime.seed = seed_lifetime
	lifetime = rand_lifetime.randf_range(lifetime-0.25,lifetime+1)
