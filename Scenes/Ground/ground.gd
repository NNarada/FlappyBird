extends Node2D
class_name Ground 


var speed = 100
var spawn_signal_emitted: bool = false

signal spawn_next_ground
signal collision

func _process(delta):
	if Globals.paused:
		return 
	position.x -= speed * delta
	if !spawn_signal_emitted and global_position.x < Globals.spawn_ground_spacing:
		spawn_next_ground.emit()
		spawn_signal_emitted = true
		



func _on_area_2d_area_entered(area):
	if area.name == "DestroyOffScreenObjects":
		queue_free()


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		collision.emit()
