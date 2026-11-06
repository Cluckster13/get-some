extends RigidBody3D
const BULLET_SPLASHscene = preload("uid://csm470cugr7ej")

@export var speed = 200
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	linear_velocity = -transform.basis.z * speed

func _on_body_entered(body: Node) -> void:
	if body.has_method("_hurt"):
		body._hurt(50)
	var splash = BULLET_SPLASHscene.instantiate()
	splash.global_position = global_position
	add_sibling(splash)


func _on_delete_timer_timeout() -> void:
	queue_free()
