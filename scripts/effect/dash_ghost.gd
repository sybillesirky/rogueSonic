extends Sprite2D

var lifeTime = 0.1

func _process(delta):
	lifeTime -= delta
	if lifeTime <= 0:
		queue_free()
