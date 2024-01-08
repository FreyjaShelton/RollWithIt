extends Node2D

var maxDistance: float = 200.0
var grappling: bool = false
var targetPoint: Vector2

func _process(delta: float) -> void:
	if grappling:
		update_line()

func update_line() -> void:
	var player_position: Vector2 = get_parent().get_node("Player").global_position
	var direction: Vector2 = targetPoint - player_position
	var distance: float = direction.length()

	if distance > maxDistance:
		end_grapple()
		return

	var ray: RayCast2D = $RayCast2D
	ray.cast_to = direction.normalized() * distance
	ray.force_raycast_update()

	if ray.is_colliding():
		$Line2D.points = [Vector2(0, 0), ray.get_collision_point() - player_position]
	else:
		end_grapple()

func start_grapple(point: Vector2) -> void:
	grappling = true
	targetPoint = point
	$Line2D.points = [Vector2(0, 0), Vector2(0, 0)]
	$Line2D.visible = true

func end_grapple() -> void:
	grappling = false
	$Line2D.visible = false
