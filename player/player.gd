class_name Player
extends CharacterBody2D

@onready var state_machine = $StateMachine
@onready var animations = $AnimationPlayer
@onready var coyote_jump_timer = $Timers/CoyoteJumpTimer
@onready var jump_buffer_timer = $Timers/JumpBuffer

@export var movement_data: PlayerMovementData

var input_axis

func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	state_machine.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	input_axis = Input.get_axis('move_left', 'move_right')
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
