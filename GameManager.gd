extends Node2D

var camera2D
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	camera2D = get_node("Camera2D")
	player = get_node("Player")
	get_window().position.x = player.position.x# - (get_window().size.x /2)
	get_window().position.y = player.position.y# - (get_window().size.y /2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	get_window().position.x = player.position.x
	get_window().position.y = player.position.y -98

	camera2D.position = get_window().position
	#get_window().size.x CLAMP THIS BITCH to 1920 ish
	#get_window().size.y CLAMP THIS BITCH to 1080 ish
