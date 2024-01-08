extends Node2D

var maxDistance: float = 200.0
var grappling: bool = false
var targetPoint: Vector2

var line2D: Line2D
var raycast2D: RayCast2D

func _ready() -> void:
	line2D = $Line2D
	raycast2D = $RayCast2D

func _process(delta: float) -> void:
	if grappling:
		update_line()

func update_line() -> void:
	var player: Node2D = get_parent().get_node_or_null("/root/World/Player")
	if player:
		var player_position: Vector2 = player.global_position
		var direction: Vector2 = targetPoint - player_position
		var distance: float = direction.length()

		if distance > maxDistance:
			end_grapple()
			return

		raycast2D.force_raycast_update()

		if raycast2D.is_colliding():
			line2D.points = [Vector2(0, 0), raycast2D.get_collision_point() - player_position]
		else:
			end_grapple()

func start_grapple(point: Vector2) -> void:
	grappling = true
	targetPoint = point
	raycast2D.target_position = targetPoint - global_position  # Set cast_to to the direction vector
	line2D.points = [Vector2(0, 0), Vector2(0, 0)]
	line2D.visible = true

func end_grapple() -> void:
	grappling = false
	line2D.visible = false
