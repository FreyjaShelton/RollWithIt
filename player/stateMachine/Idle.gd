extends State

@export var air_state: State
@export var run_state: State

func enter() -> void:
	super()

func process_physics(delta: float) -> State:
	if player.input_axis == 0:
		player.velocity.x = move_toward(player.velocity.x, 0, player.movement_data.friction * delta)
	
	player.move_and_slide()
	
	return handle_state()

func handle_state():
	if player.input_axis != 0:
		return run_state
	
	if Input.is_action_just_pressed("jump"):
		player.jump_buffer_timer.start()
		return air_state

	if !player.is_on_floor():
		player.coyote_jump_timer.start()
		return air_state
	
	return null
