extends Area

export (String) var sceneName = "Level1"



func _on_area_trigger_body_entered(body):
	if body.get_name() == "player":
		get_tree().change_scene(str("res://Scenes/" + sceneName + ".tscn"))
