extends Node

var screen_resolution: Vector2
var screen_center: Vector2
var pipe_spacing_ration: float
var spawn_horizontal_spacing: int
var current_vertical_offset: int

var ground_spacing_ratio: float
var spawn_ground_spacing: int
var paused: bool = false

func _ready():
	get_tree().get_root().connect("size_changed", Callable(self, "window_resized"))
	screen_resolution = get_viewport().size
	screen_center = screen_resolution / 2
	pipe_spacing_ration = (screen_resolution.x - 232) / screen_resolution.x 
	ground_spacing_ratio = (screen_resolution.x - 28) / screen_resolution.x
	@warning_ignore("narrowing_conversion")
	spawn_horizontal_spacing = screen_resolution.x * pipe_spacing_ration
	@warning_ignore("narrowing_conversion")
	spawn_ground_spacing = screen_resolution.x * ground_spacing_ratio

func window_resized():
	screen_resolution = get_viewport().size
	screen_center = screen_resolution / 2
	pipe_spacing_ration = (screen_resolution.x - 232) / screen_resolution.x 
	ground_spacing_ratio = (screen_resolution.x - 28) / screen_resolution.x
	@warning_ignore("narrowing_conversion")
	spawn_horizontal_spacing = screen_resolution.x * pipe_spacing_ration
	@warning_ignore("narrowing_conversion")
	spawn_ground_spacing = screen_resolution.x * ground_spacing_ratio
