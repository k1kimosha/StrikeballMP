extends CharacterBody3D

enum SPEED {WALK_SPEED = 5, SHIFT_SPEED = 2, DUCK_SPEED = 1}
const JUMP_VELOCITY = 4.5

@onready var camera = $Camera3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func is_local_auth():
	return Network.get_multiplayer_authority() == multiplayer.get_unique_id()

func _ready():
	Network.set_multiplayer_authority(str(name).to_int());
	
	if !is_local_auth(): return
	$Camera3D.current = is_local_auth();
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if !is_local_auth(): return
	
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * .005)
		camera.rotate_x(-event.relative.y * .005)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;

func _physics_process(delta):
	if !is_local_auth():
		if not Network.processed_position:
			position = Network.sync_position;
			Network.processed_position = true;
		velocity = Network.sync_moution_velocity;
		
		move_and_slide()
		return
		
	if not is_on_floor():
		velocity.y -= delta * gravity;
	
	var speed = SPEED.WALK_SPEED
	
	if Input.is_action_pressed("duck"):
		camera.position.y -= .1
	else:
		camera.position.y += .1
	camera.position.y = clamp(camera.position.y, .75, 1.5)
	
	if Input.is_action_pressed("duck"):
		speed = SPEED.DUCK_SPEED
	elif Input.is_action_pressed("shift"):
		speed = SPEED.SHIFT_SPEED
	
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY;
	
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down");
	var direction = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized();
	
	if direction:
		velocity.x = direction.x * speed;
		velocity.z = direction.z * speed;
	else:
		velocity.x = move_toward(direction.x, 0, speed);
		velocity.z = move_toward(direction.z, 0, speed);
	
	move_and_slide()
	
	Network.sync_position = position
	Network.sync_moution_velocity = velocity
