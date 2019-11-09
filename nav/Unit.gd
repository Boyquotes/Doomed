extends KinematicBody
var path = []
var path_ind = 0
var path_hit_point = false
const move_speed = 5
onready var nav = get_parent()
onready var Player = $"/root/World/Player"

# state setget
export var state = "state_detect" setget set_state, get_state
signal set_state(func_name)
func set_state(func_name): 
	state = func_name
	if !has_method(func_name): print("state [" + func_name + "] does not exsist!")
	emit_signal("set_state", func_name)
func get_state(): return state

# physics_state setget
export var physics_state = "physics_state_process" setget set_physics_state, get_physics_state
signal set_physics_state(func_name)
func set_physics_state(func_name): 
	physics_state = func_name
	if !has_method(func_name): print("physics_state [" + func_name + "] does not exsist!")
	emit_signal("set_physics_state", func_name)
func get_physics_state(): return physics_state

""" MAIN """
func _ready():
	add_to_group("units")

func _process(delta):
	if Input.is_action_just_pressed("debug"):
		print(state, " ", physics_state)
		
		if raycast_player():
			print("yes yes")
		else:
			print("no no no")
	
	if state != "" and has_method(state):
		call(state, delta)

func _physics_process(delta):
	if physics_state != "" and has_method(physics_state):
		call(physics_state, delta)

""" STATES """
func state_detect(delta):
	var space_state = get_world().get_direct_space_state()
	var hit = space_state.intersect_ray(global_transform.origin, Player.global_transform.origin)
	if hit and hit.collider == Player: 
			print("Spoted player, moving to...")
			move_to(Player.global_transform.origin)
			set_state("state_chase")

func state_chase(delta):
	if path_hit_point == true:
		print("path_hit_point ", path_hit_point)
		move_to(Player.global_transform.origin)
		path_hit_point = false

func physics_state_process(delta):
	path_process()

""" MISC """
func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_ind = 0

func path_process():
	if path_ind < path.size():
		var move_vec = (path[path_ind] - global_transform.origin)
		if move_vec.length() < 0.1:
			path_ind += 1
			if path_ind > 2:
				path_hit_point = true
		else:
			move_and_slide(move_vec.normalized() * move_speed, Vector3(0, 1, 0))

func raycast_player():
	var space_state = get_world().get_direct_space_state()
	var hit = space_state.intersect_ray(global_transform.origin, Player.global_transform.origin)
	if hit and hit.collider == Player: 
			return true