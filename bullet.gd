extends CharacterBody2D

@export var SPEED = 500
@onready var bullet = $Bullet1
@export var LIFESPAN = 2.0 #Bullet lifespan in seconds

var dir: float
var spawnPos: Vector2
var spawnRot: float

# Reference the Timer node for lifespan
@onready var lifespan_timer = $LifespanTimer
# Reference the CollisionShape2D node for detecting collisions
@onready var collision_shape = $BulletCollisionShape2D


func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	
	 # Configure and start the lifespan timer
	lifespan_timer.wait_time = LIFESPAN
	lifespan_timer.one_shot = true
	lifespan_timer.start()
	
	# Connect the collision signal
	collision_shape.connect("body_entered", self, "_on_body_entered")
	collision_shape.connect("area_entered", self, "_on_area_entered")
	
func _physics_process(delta):
	var direction = Input.get_axis("move_left", "move_right")
		# Flip the Sprite
	if direction > 0:
		bullet.flip_h = false
	elif direction < 0:
		bullet.flip_h = true
	
	velocity = Vector2(SPEED, 0).rotated(dir)
	move_and_slide()
	
func _on_LifespanTimer_timeout():
	# Destroy the bullet when the timer runs out
	print("Bullet timed out!")
	queue_free()  
	
func _on_body_entered(body):
	# Destroy the bullet when it collides with any body
	print("Bullet hit a body!")
	queue_free()

func _on_area_entered(area):
	# Destroy the bullet when it collides with any area
	print("Bullet hit an area!")
	queue_free()
