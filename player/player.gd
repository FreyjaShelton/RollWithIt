class_name Player
extends CharacterBody2D

@onready var state_machine = $StateMachine
@onready var animations = $AnimationPlayer
@onready var coyote_jump_timer = $Timers/CoyoteJumpTimer
@onready var jump_buffer_timer = $Timers/JumpBuffer
@onready var roll_idle_timer = $Timers/RollIdle
@onready var sprite = $Sprite
 
@export var movement_data: PlayerMovementData

# Reference to the two tilesets
var input_axis
var double_jump = false

func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	state_machine.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	input_axis = Input.get_axis('move_left', 'move_right')
	handle_sprite()
	handle_double_jump()
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func handle_double_jump():
	if is_on_floor():
		double_jump = true

func handle_sprite():
	sprite.flip_h = input_axis > 0
