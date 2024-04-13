extends Node2D

var ringParticleScene = preload("res://scenes/effect/object/ring_particle.tscn")


func _ready():
	$ringSprite.play()


func _on_ring_hit_box_body_entered(body):
	if body.get_parent().is_in_group("Player"):
		body.get_parent().rings += 1
		$SFX.play()
	
		var ringParticle = ringParticleScene.instantiate()
		get_parent().add_child(ringParticle)
		ringParticle.global_position = self.global_position
		$ringSprite.queue_free()
		$ringHitBox.queue_free()


func _on_sfx_finished():
	self.queue_free()
