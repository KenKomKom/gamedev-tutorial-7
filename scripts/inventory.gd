extends CanvasLayer

onready var list_item = $MarginContainer/VBoxContainer/inventory
onready var item_button_prefab = preload("res://scenes/item_button.tscn")

func _ready():
	Inventorymanager.connect("add_item", self, "add_item")

func add_item(dir_to_scene, item_name):
	var button_instance = item_button_prefab.instance()
	button_instance.dir_to_scene = dir_to_scene
	button_instance.text = item_name
	list_item.add_child(button_instance)


func _on_Exit_pressed():
	get_parent().handle_inventory()
