extends Node2D

const character = GlobalDefinitions.character
const state = GlobalDefinitions.state
const specialAction = GlobalDefinitions.specialAction

@onready var playerObject = get_parent().get_parent()

var currentSpecialAction = specialAction.None

var bounceIncrease = 0

const jumpDashParticle = preload("res://scenes/effect/sonic/jump_dash_particle.tscn")


func _specialActionTails(currentState, velocity, currentCharacter):
	var returnVelocity = velocity
	
	# Hover jump
	returnVelocity.y = -400
	currentSpecialAction = specialAction.HoverJump
	
	# Change the state and play sound effects
	get_parent()._changeState(state.Fall)
	get_parent().get_node("effectAudioPlayer").playPlayerSFX(6, currentCharacter)
	get_parent().get_node("voiceAudioPlayer").playPlayerVoice(0, currentCharacter)
	
	
	return returnVelocity


func _specialActionHomingAttack(velocity):
	var homingDestination = get_parent().get_parent().homingDestination
	var returnVelocity = 0
	if get_parent().position != homingDestination:
		get_parent()._changeState(state.Fall)
		get_parent().position = get_parent().position.move_toward(homingDestination, 17)
		returnVelocity = Vector2(0,0)
		get_parent().get_node("hitbox").monitorable = true
	else:
		get_parent()._changeState(state.Jump)
		currentSpecialAction = specialAction.None
		returnVelocity = Vector2(0,-400)
		get_parent().get_node("hitbox").monitorable = false
	
	return returnVelocity


func _specialActionBounceBracelet(currentState, velocity):
	var returnVelocity = velocity
	
	if currentSpecialAction != specialAction.Bounce:
		currentSpecialAction = specialAction.Bounce
		get_parent()._changeState(state.Fall)
		returnVelocity.x = get_parent().inputDirection * 200
		returnVelocity.y = 600
	
	return returnVelocity


func _specialActionShadow(currentState, velocity, currentCharacter):
	var returnVelocity = velocity
	
	# Chaos dash
	
	# Take the horizontal direction if there is no input direction
	if get_parent().inputDirection == 0:
		if abs(returnVelocity.x) < 600:
			returnVelocity.x = 600 * get_parent().horizontalDirection
		else:
			returnVelocity.x += 200 * get_parent().horizontalDirection
			if returnVelocity.x > get_parent().speedCap:
				returnVelocity.x = get_parent().speedCap
	
	# If there is one, take the input direction to apply the speeds instead
	else:
		if abs(returnVelocity.x) < 600:
			returnVelocity.x = 600 * get_parent().inputDirection
		else:
			returnVelocity.x += 200 * get_parent().inputDirection
			if returnVelocity.x > get_parent().speedCap:
				returnVelocity.x = get_parent().speedCap
	
	# Reverse dash if we hold against the horizontal direction
	if get_parent().inputDirection == -get_parent().horizontalDirection:
		returnVelocity = Vector2(600 * get_parent().inputDirection, 0)
	
	# Shared dash behaviour
	returnVelocity.y = 0
	currentSpecialAction = specialAction.chaosDash
	
	# Change the state and play the sound effects
	get_parent()._changeState(state.Fall)
	get_parent().get_node("effectAudioPlayer").playPlayerSFX(2, currentCharacter)
	get_parent().get_node("voiceAudioPlayer").playPlayerVoice(0, currentCharacter)
	
	return returnVelocity


func _specialActionSonic(currentState, velocity, currentCharacter):
	var returnVelocity = velocity
	
	# Jump dash
	if get_parent().inputDirection == 0:
		returnVelocity.x += 400 * get_parent().horizontalDirection
	else:
		returnVelocity.x += 400 * get_parent().inputDirection
	returnVelocity.y = -400
	currentSpecialAction = specialAction.jumpDash
	
	# Change the state and play sound effects
	get_parent()._changeState(state.Fall)
	get_parent().get_node("effectAudioPlayer").playPlayerSFX(1, currentCharacter)
	get_parent().get_node("voiceAudioPlayer").playPlayerVoice(0, currentCharacter)
	
	# Jump dash particle
	var jumpDashParticleInstance = jumpDashParticle.instantiate()
	get_parent().get_parent().add_child(jumpDashParticleInstance)
	jumpDashParticleInstance.global_position = global_position
	if get_parent().inputDirection == 0:
		jumpDashParticleInstance.get_child(0).flip_h = 0 > get_parent().horizontalDirection
	else:
		jumpDashParticleInstance.get_child(0).flip_h = 0 > get_parent().inputDirection
	
	return returnVelocity


func _doSpecialAction(currentState, velocity, currentCharacter, inputAction):
	var returnVelocity = velocity
	
	# If special actions shouldn't be allowed, just return the velocity immediately
	if !(currentState == state.Jump or currentSpecialAction == specialAction.Bounce) or !get_parent().get_node("jumpActionTimer").is_stopped():
		return velocity
	
	if !(currentSpecialAction == specialAction.None or currentSpecialAction == specialAction.Bounce):
		return velocity
	
	match inputAction:
		specialAction.jumpDash:
			returnVelocity = _specialActionSonic(currentState, velocity, currentCharacter)
		
		specialAction.chaosDash:
			returnVelocity = _specialActionShadow(currentState, velocity, currentCharacter)
		
		specialAction.Bounce:
			returnVelocity = _specialActionBounceBracelet(currentState, velocity)
		
		specialAction.HoverJump:
			returnVelocity = _specialActionTails(currentState, velocity, currentCharacter)
	
	return returnVelocity


func _specialActionsHandler(inputCharacter, currentState, velocity, delta):
	var returnVelocity = velocity
	
	# Generic bounce action behaviour
	if currentSpecialAction == specialAction.Bounce:
		bounceIncrease += 6 * delta
		if bounceIncrease > 3:
			bounceIncrease = 3
	
	# Hoverjump reduced gravity
	if currentSpecialAction == specialAction.HoverJump:
		returnVelocity.y -= 20
	
	# Special landing behaviour if bouncing
	if get_parent().is_on_floor() and currentSpecialAction == specialAction.Bounce:
		var bounceStrength = 400
		bounceStrength += 200 * bounceIncrease
		returnVelocity = bounceStrength * get_parent().get_floor_normal()
		currentSpecialAction = specialAction.None
		get_parent()._changeState(state.Jump)
		get_parent().get_node("effectAudioPlayer").playPlayerSFX(4, inputCharacter)
		return returnVelocity
	
	# Regular landing behaviour
	elif get_parent().is_on_floor():
		currentSpecialAction = specialAction.None
		get_parent().get_parent().homingDestination = Vector2(0,0)
		get_parent().get_node("hitbox").monitorable = false
		bounceIncrease = 0
	
	# Homing Attack
	if Input.is_action_just_pressed("jump") and get_parent().get_parent().homingDestination != Vector2(0,0):
		currentSpecialAction = specialAction.Homing
		get_parent()._changeState(state.Fall)
		get_parent().get_node("effectAudioPlayer").playPlayerSFX(5, inputCharacter)
	
	if currentSpecialAction == specialAction.Homing:
		returnVelocity = _specialActionHomingAttack(velocity)
		return returnVelocity
	
	# Global upward jump actions have the highest priority
	if Input.is_action_just_pressed("jump") and Input.is_action_pressed("up"):
		returnVelocity = _doSpecialAction(currentState, velocity, inputCharacter, playerObject.availableActionUpward)
	
	# Downward global actions have middle priority
	elif Input.is_action_just_pressed("jump") and Input.is_action_pressed("down"):
		returnVelocity = _doSpecialAction(currentState, velocity, inputCharacter, playerObject.availableActionDownward)
	
	# Forward jump actions have the lowest priority
	elif Input.is_action_just_pressed("jump"):
		returnVelocity = _doSpecialAction(currentState, velocity, inputCharacter, playerObject.availableActionForward)
	
	return returnVelocity
