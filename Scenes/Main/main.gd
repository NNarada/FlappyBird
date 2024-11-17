extends Node2D

var pipe_scene: PackedScene = preload("res://Scenes/Pipe/pipe.tscn")
var ground_scene: PackedScene = preload("res://Scenes/Ground/ground.tscn")
var off_screen_x_distance: int 
var off_screen_x_distance_ground: int
var off_screen_y_distance_ground: int
var random_point_near_screen_center: int

@onready var ground_spawn_point = $Ground/GroundSpawnPoint
@onready var background: Sprite2D = $Background

func _ready():
	get_tree().get_root().connect("size_changed", Callable(self, "window_resized"))
	off_screen_x_distance = $Pipes/SpawnPoint.position.x - Globals.screen_resolution.x
	find_random_point()
	Globals.current_vertical_offset = random_point_near_screen_center
	off_screen_x_distance_ground = ground_spawn_point.position.x - Globals.screen_resolution.x
	off_screen_y_distance_ground = ground_spawn_point.position.y - Globals.screen_resolution.y 
	
	background.scale.x = Globals.screen_resolution.x / 668
	background.scale.y = (Globals.screen_resolution.y - 36) /394
	background.position = Globals.screen_center
	
	for ground in $Ground/GroundSpawnPoint.get_children():
		ground.connect("collision", Callable(self, "_on_player_collision"))
	for pipe in $Pipes/SpawnPoint.get_children():
		pipe.connect("collision", Callable(self, "_on_player_collision"))
	
func _process(_delta):
	pass


func find_random_point():
		var random = randi() % 2
		if random:
			random_point_near_screen_center = (randi() % 40) + 10 
		else:
			random_point_near_screen_center = -(randi() % 40) - 10
		

func window_resized():
	#When window changes size, repostion the spawn points of the pipes and the spawn trigger area
	$Pipes/SpawnPoint.global_position = Vector2(Globals.screen_resolution.x + off_screen_x_distance, Globals.screen_center.y)
	
	#Repostion the spawn point of the ground spawning
	ground_spawn_point.position = Vector2(Globals.screen_resolution.x + off_screen_x_distance_ground, Globals.screen_resolution.y + off_screen_y_distance_ground)
	#when the window changes size, reposition the off screen object destroyer and resized it
	$DestroyOffScreenObjects.position.y = get_viewport().size.y / 2
	$DestroyOffScreenObjects/CollisionShape2D.shape.size.y = get_viewport().size.y
	
	background.scale.x = Globals.screen_resolution.x / 668
	background.scale.y = (Globals.screen_resolution.y - 36) /394
	background.position = Globals.screen_center
	
	#$Line2D.global_position.y = Globals.screen_center.y

	

func _on_pipe_spawn_next_pipe():
	find_random_point()
	Globals.current_vertical_offset = random_point_near_screen_center
	var bottom_pipe = pipe_scene.instantiate()
	var top_pipe = pipe_scene.instantiate()
	$Pipes/SpawnPoint.call_deferred("add_child", bottom_pipe)
	$Pipes/SpawnPoint.call_deferred("add_child", top_pipe)
	top_pipe.make_top_pipe()
	bottom_pipe.connect("spawn_next_pipe", Callable(self, "_on_pipe_spawn_next_pipe"))
	
	top_pipe.connect("collision", Callable(self, "_on_player_collision"))
	bottom_pipe.connect("collision", Callable(self, "_on_player_collision"))


func _on_ground_spawn_next_ground():
	var ground = ground_scene.instantiate() as Ground
	ground_spawn_point.call_deferred("add_child", ground)
	ground.connect("spawn_next_ground", Callable(self, "_on_ground_spawn_next_ground"))
	ground.connect("collision", Callable(self, "_on_player_collision"))
	

func _on_player_collision():
	print("collision")
	Globals.paused = true
