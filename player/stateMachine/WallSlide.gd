extends State

@export var idle_state: State
@export var run_state: State
@export var air_state: State
@export var ground_pound_state: State

func enter() -> void:
	super()

func process_physics(delta: float) -> State:
	if player.is_on_wall() and player.input_axis != 0:
		var wall_normal = player.get_wall_normal()
		if player.input_axis != wall_normal.x:
			player.velocity.y += gravity * delta * player.movement_data.wall_slide_speed
			player.velocity.y = clamp(player.velocity.y, 0, player.movement_data.max_wall_slide_speed)

	player.move_and_slide()
	
	if !player.is_on_floor() and Input.is_action_just_pressed("ground_pound"):
		return ground_pound_state
	
	if player.is_on_floor() and player.input_axis != 0:
		return run_state
	
	if player.is_on_floor() and player.input_axis == 0:
		return idle_state
	
	if (!player.is_on_wall() 
	or (player.is_on_wall() and player.input_axis == 0) 
	or player.jump_buffer_timer.time_left > 0):
		return air_state
	
	if Input.is_action_just_pressed("jump"):
		player.jump_buffer_timer.start()
		return air_state
	
	return null
