extends Button

var dir_to_scene : String

func _on_Button_pressed():
	var prefab = load(dir_to_scene)
	var instance = prefab.instance()
	var canvas_layer = $".".get_parent().get_parent().get_parent().get_parent()
	var player = canvas_layer.get_parent()
	var level = player.get_parent()
	instance.global_transform.origin = player.get_dir()
	level.add_child(instance)
	get_tree().paused=false
	player.handle_inventory()
	self.queue_free()
