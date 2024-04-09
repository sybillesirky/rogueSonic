extends AudioStreamPlayer2D

var jumpSound = preload("res://assets/sound/jump.wav")
var jumpDashSound = preload("res://assets/sound/sonic/jumpDash.wav")
var chaosDashSound = preload("res://assets/sound/shadow/chaosDash.wav")
var jumpShadowSound = preload("res://assets/sound/shadow/jump_shadow.wav")
var rollSound = preload("res://assets/sound/roll.wav")
var bounceSound = preload("res://assets/sound/bounceBracelet.wav")

enum character {
	Sonic,
	Shadow,
	SuperSonic
}

enum playerSFX {
	Jump,
	jumpDash,
	chaosDash,
	roll,
	bounce
}

func playPlayerSFX(soundEffect, currentCharacter):
	match soundEffect:
		playerSFX.Jump:
			if currentCharacter == character.Shadow:
				stream = jumpShadowSound
			else:
				stream = jumpSound
		
		playerSFX.jumpDash:
			stream = jumpDashSound
		
		playerSFX.chaosDash:
			stream = chaosDashSound
		
		playerSFX.roll:
			stream = rollSound
		
		playerSFX.bounce:
			stream = bounceSound
	
	self.play()
