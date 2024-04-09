extends AudioStreamPlayer2D

const voiceLinesSonic = [
	preload("res://assets/voice/sonic/dash.wav"),
	preload("res://assets/voice/sonic/hurt.wav"),
	preload("res://assets/voice/sonic/intro.wav"),
	preload("res://assets/voice/sonic/success.wav")
	
]

const voiceLinesShadow = [
	preload("res://assets/voice/shadow/dash.wav"),
	preload("res://assets/voice/shadow/hurt.wav"),
	preload("res://assets/voice/shadow/intro.wav"),
	preload("res://assets/voice/shadow/success.wav")
]

const voiceLinesSuperSonic = [
	preload("res://assets/voice/supersonic/dash.wav"),
	preload("res://assets/voice/supersonic/hurt.wav"),
	preload("res://assets/voice/supersonic/intro.wav"),
	preload("res://assets/voice/supersonic/success.wav")
]

const character = GlobalDefinitions.character


enum voiceActions {
	dash,
	hurt,
	intro,
	success
}


func playPlayerVoice(voiceAction, currentCharacter):
	# Get action ID
	var voiceID = 0
	match voiceAction:
		voiceActions.dash:
			voiceID = 0
		
		voiceActions.hurt:
			voiceID = 1
	
	match currentCharacter:
		character.Sonic:
			stream = voiceLinesSonic[voiceID]
		
		character.Shadow:
			stream = voiceLinesShadow[voiceID]
		
		character.SuperSonic:
			stream = voiceLinesSuperSonic[voiceID]
	
	self.play()
