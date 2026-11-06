extends Node
@onready var player_character: Player = $"../../.."
@onready var camera_component: Camera3D = $".."
@onready var movement_component: Node = $"../../../MovementComponent"
var on_turret : bool = false
var turret: M2Browning = null
var interaction_raycast_collider : Variant


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Interact"):
		if on_turret:
			# --- EXIT LOGIC ---
			on_turret = false
			movement_component._change_movement_perms()
			print("Dismounted")
			turret.collision_shape_3d.disabled = false
		else:
			# --- ENTER LOGIC ---
			_check_raycast_collisions()
			
			if interaction_raycast_collider is M2Browning:
				turret = interaction_raycast_collider
				on_turret = true
				movement_component._change_movement_perms()
				print("Mounted")
				turret.collision_shape_3d.disabled = true

	if Input.is_action_just_pressed("Fire"):
		if on_turret && is_instance_valid(turret):
			turret.firing = true
			turret.shot_timer.start()
	elif Input.is_action_just_released("Fire"):
		if on_turret && is_instance_valid(turret):
			turret.firing = false
	if Input.is_action_just_pressed("Charge"):
		turret._charge()
	if Input.is_action_just_pressed("Cover"):
		turret._top_cover()
	if Input.is_action_just_pressed("Escape"):
		if Input.MOUSE_MODE_CAPTURED:
			Input.MOUSE_MODE_VISIBLE
		else:
			Input.MOUSE_MODE_CAPTURED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if on_turret and is_instance_valid(turret):
		var hit = camera_component._camera_raycast(100.0)
		var target_pos: Vector3

		if hit.is_empty():
			var screen_center = get_viewport().size / 2
			target_pos = camera_component.project_position(screen_center, 100.0)
		else:
			target_pos = hit.position

		turret.root_node.look_at(target_pos, Vector3.UP)
		turret.root_node.rotate_object_local(Vector3.UP, PI)
		turret.root_node.rotate_object_local(Vector3.RIGHT, -PI/2)

		# Pass aim direction to the turret so _fire() can use it
		turret.aim_direction = (target_pos - turret.muzzle_flash_node.global_position).normalized()

signal interaction_raycast_collided
func _check_raycast_collisions() -> void:
	var new_collider : Variant = camera_component._camera_raycast(1.25).get("collider")
	if interaction_raycast_collider == new_collider:
		return
		
	interaction_raycast_collider = new_collider
	interaction_raycast_collided.emit(interaction_raycast_collider)
