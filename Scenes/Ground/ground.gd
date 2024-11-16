extends Node2D
class_name Ground 


var speed = 100
var spawn_signal_emitted: bool = false

signal spawn_next_ground


func _process(delta):
	position.x -= speed * delta
	if !spawn_signal_emitted and global_position.x < Globals.spawn_ground_spacing:
		spawn_next_ground.emit()
		spawn_signal_emitted = true
