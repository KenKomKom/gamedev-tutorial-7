extends Interactable


var dir_to_scene = "res://scenes/Box.tscn"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func interact():
	Inventorymanager.emit_signal("add_item", dir_to_scene, "Box")
	self.queue_free()

