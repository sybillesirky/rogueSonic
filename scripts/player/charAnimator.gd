extends Node2D

const character = GlobalDefinitions.character
const state = GlobalDefinitions.state
const specialAction = GlobalDefinitions.specialAction

const charGhostColors = [
	Color8(0,64,232,200),	# Sonic
	Color8(255,145,0,200),	# Shadow
	Color8(248,184,32,200),	# Tails
	Color8(255,255,0,200)	# Super Sonic
]

var characterName = str(character.keys()[0])

var ghostEffect = preload("res://scenes/effect/dash_ghost.tscn")

func _spawnDashGhosts(ghostColor):
	var ghost = ghostEffect.instantiate()
	get_parent().get_parent().add_child(ghost)
	var currentSprite = $charSprite.sprite_frames.get_frame_texture($charSprite.animation, $charSprite.frame)
	
	ghost.global_position = global_position
	ghost.global_position.y -= 16
	ghost.texture = currentSprite
	ghost.flip_h = $charSprite.flip_h
	ghost.offset.y = $charSprite.offset.y
	ghost.offset.x = $charSprite.offset.x
	ghost.rotation = $charSprite.rotation
	ghost.modulate = ghostColor


func _animsTails(currentState, currentSpecialAction):
	$charSprite.speed_scale = 1
	
	if currentSpecialAction != specialAction.None:
		match currentSpecialAction:
			specialAction.HoverJump:
				$charSprite.animation = "fly"
				$charSprite.offset.y = -3
				$charSprite.offset.x = -3
			
			specialAction.Bounce:
				$charSprite.animation = "bounce"
				$charSprite.offset.y = 0
				$charSprite.offset.x = 0
			
			specialAction.Homing:
				$charSprite.animation = "roll"
				$charSprite.offset.y = 7
				$charSprite.offset.x = 0
			
			_:
				$charSprite.animation = "dash"
				$charSprite.offset.y = -3
				$charSprite.offset.x = -3
		return
	
	match currentState:
		state.Idle:
			$charSprite.animation = "idle"
			$charSprite.offset.y = -3
			$charSprite.offset.x = -8
		
		state.Roll:
			$charSprite.rotation = 0
			$charSprite.animation = "roll"
			$charSprite.offset.y = 7
			$charSprite.offset.x = 0
		
		state.Jump:
			$charSprite.animation = "jump"
			$charSprite.offset.y = 2
			$charSprite.offset.x = 0
		
		state.Fall:
			$charSprite.animation = "fall"
			$charSprite.offset.y = -7
			$charSprite.offset.x = -3
		
		state.Crouch:
			$charSprite.animation = "crouch"
			$charSprite.offset.y = 5
			$charSprite.offset.x = -8
		
		state.Run:
			if get_parent().velocity.length() > 750:
				$charSprite.animation = "run"
			elif get_parent().velocity.length() > 600:
				$charSprite.animation = "slowrun"
			elif get_parent().velocity.length() > 400:
				$charSprite.animation = "fastwalk"
			elif get_parent().velocity.length() > 100:
				$charSprite.animation = "midwalk"
			else:
				$charSprite.animation = "walk"
			$charSprite.offset.y = -15
			$charSprite.offset.x = -7
		
		state.Hurt:
			$charSprite.animation = "hurt"
			$charSprite.offset.y = 3
			$charSprite.offset.x = -2


func _animsSuperSonic(currentState, currentSpecialAction):
	$charSprite.speed_scale = 1
	
	
	if currentSpecialAction != specialAction.None:
		match currentSpecialAction:
			specialAction.Bounce:
				$charSprite.animation = "dash"
				$charSprite.rotation += 0.5 * PI * get_parent().horizontalDirection
				$charSprite.offset.y = 0
			
			specialAction.Homing:
				$charSprite.animation = "roll"
				$charSprite.offset.y = 7
			
			_:
				$charSprite.animation = "dash"
				$charSprite.offset.y = 0
		
		return
	
	match currentState:
		state.Idle:
			$charSprite.animation = "idle"
			$charSprite.offset.y = -3
		
		state.Roll:
			$charSprite.rotation = 0
			$charSprite.animation = "roll"
			$charSprite.offset.y = 7
		
		state.Jump:
			$charSprite.animation = "jump"
			$charSprite.offset.y = 2
		
		state.Fall:
			$charSprite.animation = "fall"
			$charSprite.offset.y = -5
		
		state.Crouch:
			$charSprite.animation = "crouch"
			$charSprite.offset.y = -3
		
		state.Run:
			if get_parent().velocity.length() > 750:
				$charSprite.animation = "run"
				$charSprite.offset.y = 0
			else:
				$charSprite.animation = "midrun"
				$charSprite.offset.y = -15
		
		state.Hurt:
			$charSprite.animation = "hurt"
			$charSprite.offset.y = -3


func _animsShadow(currentState, currentSpecialAction):
	$charSprite.speed_scale = 1
	
	if currentSpecialAction != specialAction.None:
		match currentSpecialAction:
			specialAction.Bounce:
				$charSprite.animation = "bounce"
				$charSprite.offset.y = 0
			
			specialAction.Homing:
				$charSprite.animation = "roll"
				$charSprite.offset.y = 7
			
			_:
				$charSprite.animation = "chaos_dash"
				$charSprite.offset.y = 0
		
		return
	
	match currentState:
		state.Idle:
			$charSprite.animation = "idle"
			$charSprite.offset.y = -3
		
		state.Run:
			$charSprite.speed_scale = get_parent().velocity.length() / 1000 + 1
			$charSprite.animation = "run"
			$charSprite.offset.y = -13
		
		state.Jump:
			$charSprite.animation = "jump"
			$charSprite.offset.y = 2
		
		state.Fall:
			$charSprite.animation = "fall"
			$charSprite.offset.y = 2
		
		state.Roll:
			$charSprite.rotation = 0
			$charSprite.animation = "roll"
			$charSprite.offset.y = 7
		
		state.Hurt:
			$charSprite.animation = "hurt"
			$charSprite.offset.y = 0
		
		state.Crouch:
			$charSprite.animation = "crouch"
			$charSprite.offset.y = 0


func _animsSonic(currentState, currentSpecialAction):
	$charSprite.speed_scale = 1
	
	if currentSpecialAction != specialAction.None:
		match currentSpecialAction:
			specialAction.Bounce:
				$charSprite.animation = "bounce"
				$charSprite.offset.y = 0
			
			specialAction.Homing:
				$charSprite.animation = "roll"
				$charSprite.offset.y = 7
			
			_:
				$charSprite.animation = "jump_dash"
				$charSprite.offset.y = 0
		
		return
	
	match currentState:
		state.Idle:
			$charSprite.animation = "idle"
			$charSprite.offset.y = -3
		
		state.Roll:
			$charSprite.rotation = 0
			$charSprite.animation = "roll"
			$charSprite.offset.y = 7
		
		state.Jump:
			$charSprite.animation = "jump"
			$charSprite.offset.y = 2
		
		state.Fall:
			$charSprite.animation = "fall"
			$charSprite.offset.y = -5
		
		state.Crouch:
			$charSprite.animation = "crouch"
			$charSprite.offset.y = 1
		
		state.Run:
			if get_parent().velocity.length() > 750:
				$charSprite.animation = "run"
			elif get_parent().velocity.length() > 600:
				$charSprite.animation = "midrun"
			elif get_parent().velocity.length() > 400:
				$charSprite.animation = "slowrun"
			elif get_parent().velocity.length() > 100:
				$charSprite.animation = "fastwalk"
			else:
				$charSprite.animation = "walk"
			$charSprite.offset.y = -15
		
		state.Hurt:
			$charSprite.animation = "hurt"
			$charSprite.offset.y = -3


func _animatePlayer(inputCharacter, currentState, currentSpecialAction):
	# Determine the sprites to load
	if characterName != str(character.keys()[inputCharacter]).to_lower():
		characterName = str(character.keys()[inputCharacter]).to_lower()
		$charSprite.sprite_frames = load("res://assets/" + characterName + "/" + characterName + ".tres")
	
	var previousAnimation = $charSprite.animation
	
	match inputCharacter:
		character.Sonic:
			_animsSonic(currentState, currentSpecialAction)
		character.Shadow:
			_animsShadow(currentState, currentSpecialAction)
		character.SuperSonic:
			_animsSuperSonic(currentState, currentSpecialAction)
		character.Tails:
			_animsTails(currentState, currentSpecialAction)
	
	# Play the animation if we're on a new one
	if $charSprite.animation != previousAnimation:
		$charSprite.play()
	
	# Flip sprite if necessary
	$charSprite.flip_h = 0 > get_parent().horizontalDirection
	if inputCharacter == character.Tails and $charSprite.flip_h:
		$charSprite.offset.x = -$charSprite.offset.x
	if currentState == state.Hurt:
		$charSprite.flip_h = !$charSprite.flip_h
		if inputCharacter == character.Tails and $charSprite.flip_h:
			$charSprite.offset.x = -$charSprite.offset.x
	
	# Make the player translucent if we're supposed to be invulnerable
	if !get_parent().get_node("invulnTimer").is_stopped():
		$charSprite.modulate = Color8(255,255,255,100)
	else:
		$charSprite.modulate = Color8(255,255,255,255)
	
	# Spawn after-image ghosts when doing some actions
	if currentSpecialAction != specialAction.None or abs(get_parent().velocity.x) >= 900 or inputCharacter == character.SuperSonic:
		var ghostColor = charGhostColors[inputCharacter]
		_spawnDashGhosts(ghostColor)
