extends KinematicBody

export var gravity = 0.98
onready var Player = $"/root/World/Player"

func _physics_process(delta):
	var velocity = Vector3()
	
	var toPlayer = Player.global_transform.origin - global_transform.origin
	
	var move = toPlayer.normalized() * 4 if toPlayer.length() > 5 else Vector3(0,0,0)
	
	velocity.y -= gravity
	velocity = move_and_slide(velocity + move, Vector3.UP)
