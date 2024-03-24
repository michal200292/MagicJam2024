extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var PlayerID: int

@onready var anim = get_node("AnimationPlayer")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	PlayerID = multiplayer.get_unique_id()

func _physics_process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == PlayerID:
		if not is_on_floor():
			velocity.y += gravity * delta
		# Handle jump.
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("Left", "Right")
		if direction:
			velocity.x = direction * SPEED
			anim.play("Run")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			anim.play("Idle")
		
		if direction == -1:
			get_node("AnimatedSprite2D").flip_h = true
		elif direction == 1:
			get_node("AnimatedSprite2D").flip_h = false
			
		if velocity.y != 0:
			if velocity.y < 0:
				anim.play("Jump")
			else:
				anim.play("Fall")
		else:
			if velocity.x == 0:
				anim.play("Idle")
			else:
				anim.play("Run")
				
		move_and_slide()
