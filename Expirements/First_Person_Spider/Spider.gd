extends KinematicBody
var mode = "floor"
export var mouse_sensitivity = 0.3
export var controller_sensitivity = 2
onready var head = $Head
onready var camera = $Head/Camera
var velocity = Vector3()
export var speed = 10
export var acceleration = 5
export var gravity = 0.98
export var jump_power = 30
var camera_x_rotation = 0

func _ready():
	get_viewport().warp_mouse(get_viewport().get_size()*.5)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			look(event.relative * mouse_sensitivity)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			get_viewport().warp_mouse(get_viewport().get_size()*.5)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	var lookhor = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
	var lookver = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
	var look = Vector2(lookhor, lookver)
	
	look(look * controller_sensitivity)

func _physics_process(delta):
	var head_basis = head.get_global_transform().basis
	var direction = Vector3()
	var moveZ = (Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward"))
	var moveX = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	
	direction += head_basis.z * moveZ
	direction += head_basis.x * moveX
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	
	if mode == "floor":
		set_rotation_degrees(Vector3(0,0,0))
		velocity.y -= gravity
	
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y += jump_power
	
		velocity = move_and_slide(velocity, Vector3.UP)
		
		if Input.is_action_just_pressed("debug"): mode = "ceiling"
			
	
	elif mode == "ceiling":
		set_rotation_degrees(Vector3(0,0,180))
		velocity.y += gravity
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y -= jump_power
	
		velocity = move_and_slide(velocity, Vector3.DOWN)
		
		if Input.is_action_just_pressed("debug"): mode = "north"
			
		
	elif mode == "north":
		set_rotation_degrees(Vector3(-90,0,0))
		velocity.z += gravity
		
		if Input.is_action_just_pressed("jump") and is_on_ceiling(): 
			print("Jump")
			velocity.z -= jump_power
		
		velocity = move_and_slide(velocity, Vector3.BACK)
		
		if Input.is_action_just_pressed("debug"): mode = "south"
		
	elif mode == "south":
		set_rotation_degrees(Vector3(-270,0,0))
		velocity.z -= gravity
		
		if Input.is_action_just_pressed("jump") and is_on_floor(): 
			print("Jump")
			velocity.z += jump_power
		
		velocity = move_and_slide(velocity, Vector3.BACK)
		
		if Input.is_action_just_pressed("debug"): mode = "west"
	
	elif mode == "west":
		set_rotation_degrees(Vector3(0,0,-270))
		velocity.x += gravity
		
		if Input.is_action_just_pressed("jump") and is_on_floor(): 
			print("Jump")
			velocity.x -= jump_power
		
		velocity = move_and_slide(velocity, Vector3.LEFT)
		
		if Input.is_action_just_pressed("debug"): mode = "east"
	
	elif mode == "east":
		set_rotation_degrees(Vector3(0,0,-90))
		velocity.x -= gravity
		
		if Input.is_action_just_pressed("jump") and is_on_floor(): 
			print("Jump")
			velocity.x += jump_power
		
		velocity = move_and_slide(velocity, Vector3.RIGHT)
		
		if Input.is_action_just_pressed("debug"): mode = "floor"

func look(look):
	head.rotate_y(deg2rad(-look.x))
	var x_delta = look.y
	
	if camera_x_rotation + x_delta > -90 and camera_x_rotation + x_delta < 90: 
		camera.rotate_x(deg2rad(-x_delta))
		camera_x_rotation += x_delta