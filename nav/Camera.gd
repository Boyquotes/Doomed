extends Camera

const ray_length = 1000
var velocity = Vector3()

func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		var from = project_ray_origin(event.position)
		var to = from + project_ray_normal(event.position) * ray_length
		var space_state = get_world().direct_space_state
		var result = space_state.intersect_ray(from, to, [], 1)
		if result:
			get_tree().call_group("units", "move_to", result.position)
			print("from", from, "to", to)

func _process(delta):
	global_transform.origin.y += (Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")) * 1
	
	global_transform.origin.x += (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * 1
	
	