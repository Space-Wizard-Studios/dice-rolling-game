extends RigidBody3D

@export var max_ang = 20
@export var max_vel = 4

var intitial_position = Vector3()
var result = 0
var freezed = sleeping
var upmost_face = 0

func _ready():
	intitial_position = global_transform.origin
	throw()
	
func throw():
	
	global_transform.origin = intitial_position
	
	var random_ang = Vector3(
		randf_range(-max_ang,max_ang),
		randf_range(-max_ang,max_ang),
		randf_range(-max_ang,max_ang)
	)
	angular_velocity = random_ang

	var random_vel = Vector3(
		randf_range(-max_vel,max_vel),
		randf_range(0,4),
		randf_range(-max_vel,max_vel)
	)
	linear_velocity = random_vel

func _physics_process(_delta):
	if Input.is_action_just_pressed("click"):
		throw()

	if linear_velocity.length() < 0.1 and angular_velocity.length() < 0.1 and sleeping == false:
		sleeping = true

	get_result()

func get_result():
	var max_upness = 0.0
	
	for n in $Normals.get_children():
		var normal = n.global_transform.basis.y
		var upness = normal.dot(Vector3.UP) # how much it's facing up.
		if upness > max_upness:
			max_upness = upness
			upmost_face = n.face
			print(upmost_face)

func _on_die_sleeping_state_changed():
	print(sleeping)
