extends KinematicBody

export var speed = 10
export var acceleration = 5
export var gravity = 0.98
export var jump_power = 30
export var mouse_sensitivity = 0.3

onready var head = $head
onready var camera = $head/Camera

var velocity = Vector3()
var camera_x_rotation = 0

var is_sprinting = false
var is_crouching = false

var inventory_on = false
var head_basis

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	head_basis = head.get_global_transform().basis
	var movement_vector = Vector3()
	if Input.is_action_pressed("movement_forward"):
		movement_vector -= head_basis.z
	if Input.is_action_pressed("movement_backward"):
		movement_vector += head_basis.z
	if Input.is_action_pressed("movement_left"):
		movement_vector -= head_basis.x
	if Input.is_action_pressed("movement_right"):
		movement_vector += head_basis.x

	movement_vector = movement_vector.normalized()
	
	if Input.is_action_pressed("ctrl"):
		camera.fov = lerp(camera.fov, 70, 0.1)
		movement_vector = handle_sprint(movement_vector)
	else:
		camera.fov = lerp(camera.fov, 100, 0.1)
		is_sprinting = false
	if Input.is_action_pressed("shift"):
		movement_vector = handle_crouch(movement_vector)
	else:
		is_crouching=false
		self.scale.y=lerp(self.scale.y, 1,0.2)
		

	velocity = velocity.linear_interpolate(movement_vector * speed, acceleration * delta)
	velocity.y -= gravity

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += jump_power
	
	handle_inventory()
	
	velocity = move_and_slide(velocity, Vector3.UP)

func handle_sprint(movement_vector):
	if is_on_floor() and not is_crouching:
		is_sprinting=true
		return movement_vector*2
	return movement_vector

func handle_crouch(movement_vector):
	if is_on_floor() and not is_sprinting:
		is_crouching=true
		self.scale.y=lerp(self.scale.y, 0.6,0.2)
		return movement_vector*0.7
	return movement_vector

func handle_inventory():
	if Input.is_action_just_pressed("inventory") and not inventory_on:
		$inventory.visible = true
		get_tree().paused=true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		inventory_on = true
	elif inventory_on:
		$inventory.visible = false
		get_tree().paused=false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		inventory_on = false

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		head.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))

		var x_delta = event.relative.y * mouse_sensitivity
		if camera_x_rotation + x_delta > -90 and camera_x_rotation + x_delta < 90:
			camera.rotate_x(deg2rad(-x_delta))
			camera_x_rotation += x_delta

func get_dir():
	return ($head/Camera/target.global_transform.origin)
