extends KinematicBody


export var gravity = 0.98
onready var Player = $"/root/World/Player"

func _physics_process(delta):
	var velocity = Vector3()
	
	#print("Player global_transform:", Player.global_transform)
	
	var toPlayer = Player.global_transform.origin - global_transform.origin#Player.transform.origin - transform.origin
	
	#var toPlayerLength = Vector2(toPlayer.x, toPlayer.z).length()
	
	
	
	var move = toPlayer.normalized() * 4 if toPlayer.length() > 5 else Vector3(0,0,0)
	
	if Input.is_action_pressed("debug"):
		print(move)
		
	velocity.y -= gravity
	velocity = move_and_slide(velocity + move, Vector3.UP)

