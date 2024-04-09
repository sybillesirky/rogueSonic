extends Node2D

const character = GlobalDefinitions.character
const state = GlobalDefinitions.state
const specialAction = GlobalDefinitions.specialAction

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
	ghost.rotation = $charSprite.rotation
	ghost.modulate = ghostColor


func _animsSuperSonic(currentState, currentSpecialAction):
	$charSprite.speed_scale = 1
	
	
	if currentSpecialAction != specialAction.None:
		match currentSpecialAction:
			specialAction.jumpDash:
				$charSprite.animation = "dash"
				$charSprite.offset.y = 0
			
			specialAction.chaosDash:
				$charSprite.animation = "dash"
				$charSprite.offset.y = 0
			
			specialAction.Bounce:
				$charSprite.animation = "dash"
				$charSprite.rotation += 0.5 * PI * get_parent().horizontalDirection
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
			specialAction.chaosDash:
				$charSprite.animation = "chaos_dash"
				$charSprite.offset.y = 0
			
			specialAction.jumpDash:
				$charSprite.animation = "chaos_dash"
				$charSprite.offset.y = 0
			
			specialAction.Bounce:
				$charSprite.animation = "bounce"
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
			specialAction.jumpDash:
				$charSprite.animation = "jump_dash"
				$charSprite.offset.y = 0
			
			specialAction.chaosDash:
				$charSprite.animation = "jump_dash"
				$charSprite.offset.y = 0
			
			specialAction.Bounce:
				$charSprite.animation = "bounce"
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
	
	# Play the animation if we're on a new one
	if $charSprite.animation != previousAnimation:
		$charSprite.play()
	
	# Flip sprite if necessary
	$charSprite.flip_h = 0 > get_parent().horizontalDirection
	if currentState == state.Hurt:
		$charSprite.flip_h = !$charSprite.flip_h
	
	# Make the player translucent if we're supposed to be invulnerable
	if !get_parent().get_node("invulnTimer").is_stopped():
		$charSprite.modulate = Color8(255,255,255,100)
	else:
		$charSprite.modulate = Color8(255,255,255,255)
	
	# Spawn after-image ghosts when doing some actions
	if currentSpecialAction != specialAction.None or abs(get_parent().velocity.x) >= 900 or inputCharacter == character.SuperSonic:
		match inputCharacter:
			character.Sonic:
				_spawnDashGhosts(Color8(0,64,232,200))
			
			character.Shadow:
				_spawnDashGhosts(Color8(255,145,0,200))
			
			character.SuperSonic:
				_spawnDashGhosts(Color8(255,255,0,200))
			
			_:
				_spawnDashGhosts(Color8(1,1,1,1))
