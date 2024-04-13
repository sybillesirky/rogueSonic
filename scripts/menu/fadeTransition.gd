extends CanvasLayer

func fadeTransition(target_scene):
	$fadeAnim.play("dissolve")
	await $fadeAnim.animation_finished
	get_tree().change_scene_to_file(target_scene)
	$fadeAnim.play_backwards("dissolve")
