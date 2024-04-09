extends Node2D

var testDamage = false

var homingDestination = Vector2(0,0)

func _draw():
	draw_line($char.position, homingDestination, Color.BLUE, 1.0)
	draw_line($char.position, $char.position + $char.velocity, Color.GREEN, 1.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("debug_button"):
		get_tree().change_scene_to_file("res://scenes/envir/world2.tscn")
		return
	
	homingDestination = Vector2(0,0)
	var nearestHomingTarget = homingDestination
	var nearestTargetDistance = 10000
	for target in get_tree().get_nodes_in_group("homingAttackTarget"):
		var targetPosition = target.position - self.position
		var targetDistance = abs(targetPosition.x - $char.position.x)
		var playerFacingTarget = ($char.position.x - targetPosition.x) * $char.horizontalDirection < 0
		var targetBelowPlayer = $char.position.y - targetPosition.y < 0
		if targetDistance < nearestTargetDistance and targetBelowPlayer and playerFacingTarget and targetDistance < 200:
			nearestHomingTarget = targetPosition
			nearestTargetDistance = targetDistance
		
	homingDestination = nearestHomingTarget
	if homingDestination == Vector2(0,0):
		homingDestination = $char.position
	
	if Input.is_action_just_released("debug_button") and homingDestination != $char.position:
		$char.position = homingDestination
		$char.velocity = Vector2(0, -399)
	
	queue_redraw()
		
	# Follow the character
	$playerCamera.position = $char.position
	
	$playerCamera/DEBUG.text = str($char.state.keys()[$char.currentState]) + "\n" + str($char.global_position)

func _getHurt(body):
	if body == $char and $char.currentState != GlobalDefinitions.state.Hurt and $char/invulnTimer.is_stopped():
		$char._changeState(5)
