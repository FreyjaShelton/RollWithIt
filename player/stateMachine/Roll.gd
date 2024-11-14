extends State

@export var idle_state: State
@export var run_state: State
@export var air_state: State

func enter() -> void:
	super()
	var new_texture = preload("res://roll.png")
	player.sprite.texture = new_texture

func process_physics(delta: float) -> State:
	if player.input_axis != 0:
		player.velocity.x = move_toward(player.velocity.x, player.input_axis * player.movement_data.roll_speed, player.movement_data.roll_acceleration * delta)
	
	if player.input_axis == 0:
		player.velocity.x = move_toward(player.velocity.x, 0, player.movement_data.roll_friction * delta)
	
	player.move_and_slide()
	
	return handle_state()

func handle_state():
	
	# Timer to handle the player returning to idle state after a set amount of time
	# need to start timer if player isnt moving and on the ground
	# then when the timer ends, return to the idle state
	#if player.is_on_floor() and player.input_axis == 0 and player.roll_idle_timer.is_stopped():
	#	player.roll_idle_timer.start()
	
	if Input.is_action_just_pressed("roll"):
		if player.input_axis == 0:
			print("return to idle")
			return idle_state
		else:
			print("return to run")
			return run_state
	
	if Input.is_action_just_pressed("jump"):
		player.jump_buffer_timer.start()
		return air_state

	if !player.is_on_floor():
		player.coyote_jump_timer.start()
		return air_state
	
	return null
