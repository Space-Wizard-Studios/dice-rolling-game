extends Marker3D

@export var mouse_sensitivity = 0.5
@onready var camera = $CameraArm/Camera
var zoom_target = 2.1
var camera_change = Vector2()

func _ready():
	set_as_top_level(true)
	camera.position.z = zoom_target
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_just_pressed("click"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Save mouse movement to the variable which will be used in aim()
	# if event is InputEventMouseMotion and Input.is_action_pressed("mmb"):
	
	if event is InputEventMouseMotion:
		camera_change = event.relative
	camera_zoom()
	
func _physics_process(delta):
	rotate_camera(delta)
	camera.position.z = lerp(camera.position.z, zoom_target, 5.0*delta)

func camera_zoom():
	return
	if Input.is_action_just_pressed("mmb_up") and zoom_target > 2:
		zoom_target *= 0.5
	if Input.is_action_just_pressed("mmb_down")  and zoom_target < 20:
		zoom_target *= 1.5
	
	if Input.is_action_just_pressed("mmb"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Input.is_action_just_released("mmb"):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		
func rotate_camera(_delta):
	if not camera_change.length(): return # if mouse was moved and camera needs to turn
	# Rotate horizontally
	rotate_y(deg_to_rad(-camera_change.x * mouse_sensitivity))
	$CameraArm.rotate_x(deg_to_rad(-camera_change.y * mouse_sensitivity))
	$CameraArm.rotation_degrees.x = clamp($CameraArm.rotation_degrees.x,-90,-10)
	# Reset camera change after it has been performed
	camera_change = Vector2()


var target_camera_rotation = 0
func rotate_camera_simple(_delta):
	rotation.y = lerp_angle(rotation.y, target_camera_rotation,0.1)
	if Input.is_action_just_pressed("rotate_camera_cw"):
		target_camera_rotation -= deg_to_rad(45)
		#camera_rig.rotate_y(deg2rad(-camera_rotation_speed * delta)) 
	if Input.is_action_just_pressed("rotate_camera_ccw"):
		target_camera_rotation += deg_to_rad(45)
		#camera_rig.rotate_y(deg2rad(camera_rotation_speed * delta)) 
