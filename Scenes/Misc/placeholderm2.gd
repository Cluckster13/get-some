extends StaticBody3D
class_name M2Browning
@onready var root_node: Node3D = $"../Sketchfab_model/bb64d2cf157e43bd898d0af139db59ec_fbx/RootNode"
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
var top_cover_open : bool = false
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var muzzle_flash_node: Node3D = $"../Sketchfab_model/bb64d2cf157e43bd898d0af139db59ec_fbx/RootNode/M2 Browning 2/M2 Browning 2 Barrel 1/MuzzleFlashNode"
@onready var shot_sound: AudioStreamPlayer = $"../AudioStreamPlayer3D/50Singleshot"
@onready var shot_timer : Timer = $"../ShotTimer"
@onready var muzzle_flash_omni_light: OmniLight3D = $"../Sketchfab_model/bb64d2cf157e43bd898d0af139db59ec_fbx/RootNode/M2 Browning 2/M2 Browning 2 Barrel 1/MuzzleFlashOmniLight"
const _50_CAL_BULLET = preload("uid://115ocl1ynm44")



var firing : bool = false

func _ready() -> void:
	muzzle_flash_omni_light.light_energy = 0

func _top_cover():
	if top_cover_open:
		animation_player.play("M2Browning/CloseTopCover")
		# Wait for the specific signal that the animation is done
		await animation_player.animation_finished 
		top_cover_open = false
	else:
		# Play the opening animation
		animation_player.play("M2Browning/OpenTopCover")
		await animation_player.animation_finished
		top_cover_open = true
		# The AnimationPlayer will now "rest" on the last frame

func _charge() -> void:
	animation_player.play("M2Browning/Charge")


var aim_direction: Vector3 = Vector3.FORWARD
func _fire() -> void:
	var bullet: RigidBody3D = _50_CAL_BULLET.instantiate()
	add_sibling(bullet)
	bullet.global_position = muzzle_flash_node.global_position
	bullet.linear_velocity = aim_direction * bullet.speed
	animation_player.play("M2Browning/Firing")
	shot_sound.play()
	
	for i in muzzle_flash_node.get_children():
		i.emitting = true
	


func _on_shot_timer_timeout() -> void:
	if firing:
		_fire()
		
	else:
		shot_timer.stop()
		animation_player.stop()
		for i in muzzle_flash_node.get_children():
			i.emitting = false
