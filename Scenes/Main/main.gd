extends Node2D

var pipe_scene: PackedScene = preload("res://Scenes/Pipe/pipe.tscn")
var ground_scene: PackedScene = preload("res://Scenes/Ground/ground.tscn")
var off_screen_x_distance: int 
var off_screen_x_distance_ground: int
var off_screen_y_distance_ground: int
var random_point_near_screen_center: int

@onready var ground_spawn_point = $Ground/GroundSpawnPoint

func _ready():
	get_tree().get_root().connect("size_changed", Callable(self, "window_resized"))
	off_screen_x_distance = $Pipes/SpawnPoint.position.x - Globals.screen_resolution.x
	find_random_point()
	Globals.current_vertical_offset = random_point_near_screen_center
	off_screen_x_distance_ground = ground_spawn_point.position.x - Globals.screen_resolution.x
	off_screen_y_distance_ground = ground_spawn_point.position.y - Globals.screen_resolution.y 
	
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
	#$DestoyOffScreenObjects.position.y = get_viewport().size.y / 2
	#$DestoyOffScreenObjects/CollisionShape2D.shape.size.y = get_viewport().size.y
	
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
	


func _on_ground_spawn_next_ground():
	var ground = ground_scene.instantiate() as Ground
	ground_spawn_point.call_deferred("add_child", ground)
	ground.connect("spawn_next_ground", Callable(self, "_on_ground_spawn_next_ground"))
