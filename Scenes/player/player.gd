extends RigidBody2D

func _physics_process(_delta):
	if linear_velocity.y >= 0:
		angular_velocity += linear_velocity.y / 1000
	else:
		angular_velocity += 0.1
	
	angular_velocity = min(angular_velocity, 3)
		
	if angular_velocity >= 0 and rotation_degrees > 70:
		angular_velocity = 0
		rotation_degrees = 70
	if angular_velocity < 0 and rotation_degrees < -30:
		angular_velocity = 0
		rotation_degrees = -30
	
func _input(event):
	if Globals.paused:
		return 
	if event.is_action_pressed("Flap"):
		angular_velocity = -8
		linear_velocity.y = -200
