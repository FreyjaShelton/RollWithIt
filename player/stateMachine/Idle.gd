extends State

@export var air_state: State
@export var run_state: State

func enter() -> void:
	super()

func process_physics(delta: float) -> State:
	player.velocity.y += gravity * delta
	player.velocity.x = move_toward(player.velocity.x, 0, player.movement_data.friction * delta)
	player.move_and_slide()
	
	if Input.is_action_just_pressed('move_left') or Input.is_action_just_pressed('move_right'):
		return run_state
	
	if player.is_on_floor() and Input.is_action_just_pressed("jump"):
		player.jump_buffer_timer.start()
		return air_state
	
	if !player.is_on_floor():
		player.coyote_jump_timer.start()
		return air_state
	
	return null
