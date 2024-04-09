extends AudioStreamPlayer

var lockOnSound = preload("res://assets/sound/lockOn.wav")

func _playLockOn():
	stream = lockOnSound
	self.play()
