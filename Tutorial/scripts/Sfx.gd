extends Node

func play(sound):
	if sound == null:
		return
	var sfx = AudioStreamPlayer.new()
	get_tree().get_root().add_child(sfx)
	sfx.set_stream(load("res://" + sound))
	sfx.connect("finished", sfx, "queue_free")
	sfx.play()