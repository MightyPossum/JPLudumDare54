extends Node2D

var trapFloor
var key_value = 1
var exploded =  false
@export var ground_impact_particle : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	trapFloor = get_parent().get_node('FeliciaBye')

func handle_hitting_something():
	for i in 1000:
		var particle = ground_impact_particle.instantiate()
		get_parent().add_child(particle)
		particle.transform = trapFloor.transform
		particle.position.x += 75
		particle.position.y += 25
		get_parent().get_node('GroundGoBang').play()
		particle.initialize(0.1, 4)

func _on_area_2d_area_entered(area):
	if area.is_in_group('Projectile') && not exploded:
		handle_hitting_something()
		trapFloor.queue_free()
		exploded = true
		
