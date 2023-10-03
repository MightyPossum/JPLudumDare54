extends Node2D

var camera2D
var player
var door
var playWindow
var onBorder = false
var onBottomBorder = false
@export var horizontalDeadzone = 98
@export var verticalDeadzone = 50
var GLOBAL_VALUES
var player_ready = false
var boss_level = false

var startTimer = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	GLOBAL_VALUES = get_node("/root/GlobalValues")
	playWindow = get_window()
	
	if GLOBAL_VALUES.IN_GAME:
		playWindow.size.x = GLOBAL_VALUES.SCREEN_SIZE_X
		playWindow.size.y = GLOBAL_VALUES.SCREEN_SIZE_Y
	
	DisplayServer.window_set_title("Please don't mess this up!, we have limited space")
	camera2D = get_node("Camera2D")
	player = get_node("Player")
	door = get_node("door")
	
	playWindow.position.x = player.position.x
	playWindow.position.y = player.position.y + verticalDeadzone

	camera2D.position = player.position
	camera2D.position.y -= 65

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if GLOBAL_VALUES.IN_MENU:
		startTimer += _delta
		
		if startTimer >= 25:
			DisplayServer.window_set_title("Psst... have you tried shooting the sign")
		elif startTimer >= 14:
			DisplayServer.window_set_title("WASD to move, Space Bar to shoot")
		elif startTimer >= 13:
			DisplayServer.window_set_title("Why don't you start the game?.............")
		elif startTimer >= 12:
			DisplayServer.window_set_title("Why don't you start the game?............")
		elif startTimer >= 11:
			DisplayServer.window_set_title("Why don't you start the game?...........")
		elif startTimer >= 10:
			DisplayServer.window_set_title("Why don't you start the game?..........")
		elif startTimer >= 9:
			DisplayServer.window_set_title("Why don't you start the game?.........")
		elif startTimer >= 8:
			DisplayServer.window_set_title("Why don't you start the game?........")
		elif startTimer >= 7:
			DisplayServer.window_set_title("Why don't you start the game?.......")
		elif startTimer >= 6:
			DisplayServer.window_set_title("Why don't you start the game?.....")
		elif startTimer >= 5:
			DisplayServer.window_set_title("Why don't you start the game?....")
		elif startTimer >= 4:
			DisplayServer.window_set_title("Why don't you start the game?...")
		elif startTimer >= 3:
			DisplayServer.window_set_title("Why don't you start the game?..")
		elif startTimer >= 2:
			DisplayServer.window_set_title("Why don't you start the game?.")
		elif startTimer >= 1:
			DisplayServer.window_set_title("Why don't you start the game?")
			
	if not player_ready:
		if player.is_on_floor():
			print('FLIP THE SCRIPT')
			player_ready = true
			GLOBAL_VALUES.ALLOW_MOVEMENT = true
			if GLOBAL_VALUES.CURRENT_LEVEL == 3:
				boss_level = true
			
	if not GLOBAL_VALUES.IN_MENU and not boss_level:
		if not player.exit:   
			if onBorder == false:
				if player.position.x <= playWindow.position.x - horizontalDeadzone:
					playWindow.position.x = player.position.x + horizontalDeadzone
				
				elif player.position.x >= playWindow.position.x + horizontalDeadzone:
					playWindow.position.x = player.position.x - horizontalDeadzone

			if onBottomBorder == false:
				if player.position.y <= playWindow.position.y - verticalDeadzone:
					playWindow.position.y = player.position.y + verticalDeadzone

				elif player.position.y >= playWindow.position.y + verticalDeadzone:
					playWindow.position.y = player.position.y - verticalDeadzone

			camera2D.position = playWindow.position

			if playWindow.position.x >= 1920 - playWindow.size.x && player.position.x >= 1920 - playWindow.size.x:
				playWindow.position.x = 1920 - playWindow.size.x
				onBorder = true
			elif playWindow.position.x <= 0 && player.position.x <= 0:
				playWindow.position.x = 0
				onBorder = true
			else:
				onBorder = false
			
			if GLOBAL_VALUES.RESTRAIN_SCREEN and player_ready and not player.i_am_dead:
				print(GLOBAL_VALUES.RESTRAIN_SCREEN)
				var y_limit_bottom = 890
				
				var y_limit_top = 25
				if playWindow.position.y >= y_limit_bottom  && player.position.y >= y_limit_bottom :
					playWindow.position.y = y_limit_bottom 
					onBottomBorder = true
				elif playWindow.position.y <= y_limit_top  && player.position.y <= y_limit_top :
					playWindow.position.y = y_limit_top 
					onBottomBorder = true
				else:
					onBottomBorder = false
	if boss_level:
		playWindow.size.x = 1020
		playWindow.size.y = 800
	elif GLOBAL_VALUES.IN_GAME && not player.exit:
		playWindow.size.x = GLOBAL_VALUES.SCREEN_SIZE_X
		playWindow.size.y = GLOBAL_VALUES.SCREEN_SIZE_Y



func _on_area_2d_2_body_exited(body):
	if body.is_in_group("Player"):
		GLOBAL_VALUES.IN_MENU = false
		GLOBAL_VALUES.ALLOW_MOVEMENT = false
		GLOBAL_VALUES.GAME_FALLING = true
		
		


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		GLOBAL_VALUES.IN_GAME = true
		GLOBAL_VALUES.RESTRAIN_SCREEN = true
		GLOBAL_VALUES.CURRENT_LEVEL = 1
		GLOBAL_VALUES.HIGHEST_LEVEL = 1 
		get_tree().change_scene_to_file("res://MainScene.tscn")


func _leave_game(body):
	if body.is_in_group('Player'):
		player_ready = false
		GLOBAL_VALUES.GAME_FALLING = true
		boss_level = false


func the_end(body):
	get_tree().quit()
