extends Node2D

var speed = 5
var lifetime = 0.0
var x_direction
var y_direction
var counter= 0
var bouncy_timer = 3
@export var health_impact_particle_1 : PackedScene
@export var health_impact_particle_2 : PackedScene

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
	y_direction = rand_y.randf_range(-1,-0.5)


func _physics_process(delta):

	counter += delta
	if counter >= bouncy_timer:
		pass
	else:
		position += transform.x * speed * x_direction
		position += transform.y * speed * y_direction

func handle_hitting_something():
	for i in 15:
		var health_1 = health_impact_particle_1.instantiate()
		var health_2 = health_impact_particle_2.instantiate()
		
		get_parent().get_parent().add_child(health_1)
		get_parent().get_parent().add_child(health_2)
		health_1.transform = transform
		health_2.transform = transform
		health_1.initialize(0.01, 2)
		health_2.initialize(0.01, 2)
		
func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		get_parent().get_node("PowerUp2Audio").play()
		body.upgrade_attack_speed(400, 0.02)
		body.upgrade2_aquired = true
		DisplayServer.window_set_title('Attack Boosted!. "Kick some ASS! (Just not mine)"')
		handle_hitting_something()
		queue_free()
