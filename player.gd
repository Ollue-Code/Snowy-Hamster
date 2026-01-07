extends CharacterBody2D

@onready var camera: Camera2D = $Camera
@onready var sprite: AnimatedSprite2D = $Sprite

@onready var spawner : MultiplayerSpawner = get_parent().get_node_or_null("MultiplayerSpawner")

@onready var direction = "S"
@onready var speed = 100

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _ready() -> void:
	if not is_multiplayer_authority():
		return

func _physics_process(_delta: float) -> void:
	if not is_multiplayer_authority():
		return
	
	manage_camera()
	move()
	animations()
	camera.make_current()

func get_direction():
	var input_vector = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	if input_vector == Vector2(0,-1):
		direction = "N"
	elif input_vector == Vector2(0,1):
		direction = "S"
	elif input_vector == Vector2(1,0):
		direction = "E"
	elif input_vector == Vector2(-1,0):
		direction = "W"

func animations():
	if velocity == Vector2(0,0):
		sprite.play("walk")
		sprite.pause()
	else:
		sprite.play("walk")

func manage_camera():
	var dir = get_global_mouse_position() - sprite.global_position
	sprite.rotation = dir.angle() - PI / 2


func move():
	var input_direction = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	velocity = input_direction * speed
	move_and_slide()
