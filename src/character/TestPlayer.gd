extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -575.0
const MULTIPLICATOR = 1

var PlayerID: int

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	PlayerID = multiplayer.get_unique_id()

func _physics_process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == PlayerID:
		if not is_on_floor():
			velocity.y += gravity * delta * (MULTIPLICATOR ** 2)

		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY * MULTIPLICATOR 

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED * MULTIPLICATOR
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()