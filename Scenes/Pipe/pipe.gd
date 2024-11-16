extends Node2D


const speed: int = 100
var top_bottom_padding = 50
var spawn_signal_emitted: bool = false
var pipe_body_rescale_amount: float 
@export var is_bottom_pipe: bool = true

signal collision
signal spawn_next_pipe

func _ready():
	get_tree().get_root().connect("size_changed", Callable(self, "window_resized"))
	if is_bottom_pipe:
		global_position.y += (256 + top_bottom_padding - Globals.current_vertical_offset)
		pipe_body_rescale_amount = (Globals.screen_resolution.y - global_position.y) / 128 
		
	if !is_bottom_pipe:
		global_position.y -= (256 + top_bottom_padding + Globals.current_vertical_offset)
		pipe_body_rescale_amount = global_position.y / 128
		rotate(PI)
		
	$PipeBody.scale.y += pipe_body_rescale_amount


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Globals.paused:
		return 
	position.x -= speed * delta
	if !spawn_signal_emitted and global_position.x < Globals.spawn_horizontal_spacing:
		spawn_next_pipe.emit()
		spawn_signal_emitted = true

func window_resized():
	pipe_body_rescale_amount = abs(Globals.screen_resolution.y - global_position.y) / 128
	$PipeBody.scale.y += pipe_body_rescale_amount

func make_top_pipe():
	is_bottom_pipe = false


func _on_pipe_end_area_entered(area):
	if area.name == "DestroyOffScreenObjects":
		queue_free()


func _on_pipe_body_area_entered(area):
	if area.name == "DestroyOffScreenObjects":
		queue_free()



func _on_pipe_body_body_entered(body):
	if body.name == "Player":
		collision.emit()


func _on_pipe_end_body_entered(body):
	if body.name == "Player":
		collision.emit()
