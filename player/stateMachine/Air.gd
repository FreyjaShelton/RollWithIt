extends State

@export var idle_state: State
@export var run_state: State
@export var ground_pound_state: State
@export var wall_slide_state: State

@onready var left_inner = $"../../LeftInner"
@onready var left_outer = $"../../LeftOuter"
@onready var right_inner = $"../../RightInner"
@onready var right_outer = $"../../RightOuter"

var double_jump = false
var jump = false

func enter() -> void:
	super()

func process_physics(delta: float) -> State:
	player.velocity.y += gravity * delta * player.movement_data.gravity_scale
	
	if player.is_on_floor(): 
		jump = true
		double_jump = true
	
	if Input.is_action_just_pressed("jump") and player.jump_buffer_timer.time_left == 0.0:
		player.jump_buffer_timer.start()
	
	handle_jump()
	
	if !player.is_on_floor():
		handle_variable_jump()
		handle_double_jump()
		handle_wall_jump()
	
	handle_ledge_push()
	
	if player.input_axis != 0:
		player.velocity.x = move_toward(player.velocity.x, player.input_axis * player.movement_data.speed, player.movement_data.air_acceleration * delta)
	elif player.input_axis == 0:
		player.velocity.x = move_toward(player.velocity.x, 0, player.movement_data.air_resistance * delta)

	player.move_and_slide()
	
	if !player.is_on_floor():
		if Input.is_action_just_pressed("ground_pound"):
			return ground_pound_state
		if player.is_on_wall() and !Input.is_action_just_pressed("jump") and player.velocity.y > 0:
			return wall_slide_state
	
	
	if player.is_on_floor() and !Input.is_action_just_pressed("jump"):
		if player.input_axis != 0:
			return run_state
		return idle_state
	
	return null

func handle_jump():
	if (player.is_on_floor() or player.coyote_jump_timer.time_left > 0.0) and jump:
		if Input.is_action_just_pressed("jump") or player.jump_buffer_timer.time_left > 0.0:
			player.velocity.y = player.movement_data.jump_velocity
			player.jump_buffer_timer.stop()
			jump = false

func handle_variable_jump():
	if Input.is_action_just_released("jump") and player.velocity.y < player.movement_data.jump_velocity/2:
		player.velocity.y = player.movement_data.jump_velocity/2

func handle_double_jump():
	if Input.is_action_just_pressed("jump") and double_jump and !player.is_on_wall():
		player.velocity.y = player.movement_data.jump_velocity * 0.8
		player.jump_buffer_timer.stop()
		double_jump = false

func handle_wall_jump():
	if player.is_on_wall():
		var wall_normal = player.get_wall_normal()
		if Input.is_action_just_pressed("jump") or player.jump_buffer_timer.time_left > 0.0:
			player.jump_buffer_timer.stop()
			player.velocity.x = wall_normal.x * player.movement_data.speed
			player.velocity.y = player.movement_data.jump_velocity

func handle_ledge_push():
	if player.velocity.y < player.movement_data.jump_velocity/2:
		# Up right side
		if (right_outer.is_colliding() 
		and !right_inner.is_colliding() 
		and !left_inner.is_colliding() 
		and !left_outer.is_colliding()):
			player.global_position.x +=5
		
		# Up left side
		if (left_outer.is_colliding() 
		and !left_inner.is_colliding() 
		and !right_inner.is_colliding() 
		and !right_outer.is_colliding()):
			player.global_position.x -=5
