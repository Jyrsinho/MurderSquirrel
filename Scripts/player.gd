extends CharacterBody2D

@onready var main = get_tree().get_root().get_node("main") #TODO Poista tämä ekana jos ei toimi
@onready var bullet = load("res://bullet.tscn")

const SPEED = 150.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var player_sprite = $PlayerSprite

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Handle shoot
	if Input.is_action_just_pressed("shoot"):	
		shoot()
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the Sprite
	if direction > 0:
		player_sprite.flip_h = false
	elif direction < 0:
		player_sprite.flip_h = true
	
	# Play animations
	if is_on_floor():
		if direction == 0:
			player_sprite.play("default")
		else:
			player_sprite.play("run")
	else:
		player_sprite.play("jump")
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func shoot ():
	var instance = bullet.instantiate()
	if player_sprite.flip_h:
		instance.dir = global_rotation + PI
	else:
		instance.dir = global_rotation
	instance.spawnPos = global_position
	# instance.spawnRot = global_rotation
	main.add_child(instance)
	print("pam pam!")
	
	 
