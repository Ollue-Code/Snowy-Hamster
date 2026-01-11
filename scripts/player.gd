extends CharacterBody2D

@onready var camera: Camera2D = $Camera
@onready var sprite: AnimatedSprite2D = $Sprite

@onready var spawner : MultiplayerSpawner = get_parent().get_node_or_null("MultiplayerSpawner")

@onready var direction = "S"
@onready var speed = 100

@onready var main: ColorRect = $Colour/Main
@onready var right_band: ColorRect = $Colour/Right_Band
@onready var left_band: ColorRect = $Colour/Left_Band
@onready var main_band: ColorRect = $Colour/Main_Band

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	
func _ready() -> void:
	if not is_multiplayer_authority():
		return
	camera.call_deferred("make_current")
	call_deferred("send_colours")
	
func _physics_process(_delta: float) -> void:
	if not is_multiplayer_authority():
		return
	
	manage_camera()
	move()
	animations()

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
	var angle_dir = get_global_mouse_position() - sprite.global_position
	var angle = angle_dir.angle() - PI / 2
	sprite.rotation = angle
	main.rotation = angle
	main_band.rotation = angle
	left_band.rotation = angle
	right_band.rotation = angle


func move():
	var input_direction = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	velocity = input_direction * speed
	move_and_slide()

func send_colours():
	spawner.rpc_id(1, "set_player_colours", Local_Global.main_colour,
	Local_Global.main_band_colour,
	Local_Global.right_band_colour,
	Local_Global.left_band_colour)

@rpc("any_peer", "call_local") 
func set_colours(main_colour,main_band_colour,right_band_colour,left_band_colour):
	main.color = main_colour
	main_band.color = main_band_colour
	right_band.color = right_band_colour
	left_band.color = left_band_colour
