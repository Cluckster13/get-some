extends Node


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var mouse_sens = 0.4
var swap_x : int = -1
var swap_y : int = -1
@onready var player_character: CharacterBody3D = $".."
@onready var head: Node3D = $"../Head"
var allowed_move : bool = true
var direction = Vector3.ZERO
var lerp_speed = 10.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not player_character.is_on_floor():
		player_character.velocity += player_character.get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and player_character.is_on_floor():
		player_character.velocity.y = JUMP_VELOCITY
	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if allowed_move:
		var input_dir := Input.get_vector("Left", "Right", "Forward", "Back")
	
		direction = lerp(direction, (player_character.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta * lerp_speed)
		if direction:
			player_character.velocity.x = direction.x * SPEED
			player_character.velocity.z = direction.z * SPEED
			#SquadFormationMarkers.rotation.y = direction.z
		else:
			player_character.velocity.x = move_toward(player_character.velocity.x, 0, SPEED)
			player_character.velocity.z = move_toward(player_character.velocity.z, 0, SPEED)
		
		player_character.move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		player_character.rotate_y(deg_to_rad(event.relative.x * mouse_sens * swap_x))
		head.rotate_x(deg_to_rad(event.relative.y * mouse_sens * swap_y))
		head.rotation.x = clamp(head.rotation.x,deg_to_rad(-89),deg_to_rad(89))

func _change_movement_perms() -> void:
	if allowed_move:
		allowed_move = false
	else:
		allowed_move = true
