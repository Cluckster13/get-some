extends Camera3D
@onready var player_character: Player = $"../.."

func _camera_raycast(distance : float) -> Dictionary:
	var space_state = get_world_3d().direct_space_state # tells camera we're working in 3d
	var screen_center = get_viewport().size /2
	var ray_origin = project_ray_origin(screen_center)
	var ray_end = ray_origin + project_ray_normal(screen_center) * distance # input for distance depending on weapon/tool use
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.collide_with_bodies = true
	query.exclude = [player_character.get_rid()]
	var ray_result : Dictionary = space_state.intersect_ray(query)
	return ray_result
