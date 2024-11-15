extends State

@export var idle_state: State
@export var run_state: State
@export var air_state: State

var is_idle: bool

func enter() -> void:
	super()
	var new_texture = preload("res://roll.png")
	player.sprite.texture = new_texture
	is_idle = false

func process_physics(delta: float) -> State:
	if player.input_axis != 0:
		player.velocity.x = move_toward(player.velocity.x, player.input_axis * player.movement_data.roll_speed, player.movement_data.roll_acceleration * delta)
	
	if player.input_axis == 0:
		player.velocity.x = move_toward(player.velocity.x, 0, player.movement_data.roll_friction * delta)
	
	player.move_and_slide()
	
	return handle_state()

func _on_roll_idle_timeout() -> void:
	is_idle = true
	player.roll_idle_timer.stop()
	print("timeout")

func handle_state():
	if is_idle:
		print("go to idle state")
		return idle_state
	
	if player.is_on_floor() and player.input_axis == 0 and player.roll_idle_timer.is_stopped():
		player.roll_idle_timer.start()
		print("start idle timer")
	
	if Input.is_action_just_pressed("roll"):
		if player.input_axis == 0:
			return idle_state
		else:
			return run_state
	
	if Input.is_action_just_pressed("jump"):
		player.jump_buffer_timer.start()
		return air_state

	if !player.is_on_floor():
		player.coyote_jump_timer.start()
		return air_state
	
	return null
