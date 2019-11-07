extends KinematicBody

var velocity = Vector3()
export var gravity = 0.98
onready var Player = $"/root/World/Player"

func _physics_process(delta):
	var toPlayer = Player.transform.origin - transform.origin
	
	var toPlayerLength = Vector2(toPlayer.x, toPlayer.z).length()
	
	
	if Input.is_action_just_pressed("debug"):
		print(toPlayerLength)

	var move = toPlayer if toPlayerLength > 2 else Vector3(0,0,0)
	
	move = move.normalized() * 3
		
	velocity.y -= gravity
	velocity = move_and_slide(velocity, Vector3.UP)

