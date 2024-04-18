## Implementasi sprint
Untuk melakukan aksi sprint, diperlukan input mapping baru. Jadi di buat input mapping bernama ctrl dengan mapping ke key 'control'
Dilakukan dengan memanfaatkan algoritma berikut pada file player.gd
```
func handle_crouch(movement_vector):
	if is_on_floor() and not is_sprinting:
		is_crouching=true
		self.scale.y=lerp(self.scale.y, 0.6,0.2)
		return movement_vector*0.7
	return movement_vector
```
dan pada function _physics_process(delta) ditambahkan
```
	if Input.is_action_pressed("ctrl"):
		camera.fov = lerp(camera.fov, 70, 0.1)
		movement_vector = handle_sprint(movement_vector)
	else:
		camera.fov = lerp(camera.fov, 100, 0.1)
		is_sprinting = false
```
## Implementasi crouch
Untuk melakukan aksi crouch, diperlukan input mapping baru. Jadi di buat input mapping bernama shift dengan mapping ke key 'shift'
Dimanfaatkan algoritma berikut pada file plaer.gd
```
func handle_crouch(movement_vector):
	if is_on_floor() and not is_sprinting:
		is_crouching=true
		self.scale.y=lerp(self.scale.y, 0.6,0.2)
		return movement_vector*0.7
	return movement_vector
```
dan pada function _physics_process(delta) ditambahkan
```
	if Input.is_action_pressed("shift"):
		movement_vector = handle_crouch(movement_vector)
	else:
		is_crouching=false
		self.scale.y=lerp(self.scale.y, 1,0.2)
```

## Implementasi inventory
Untuk membuka inventory, diperlukan input mapping baru. Jadi di buat input mapping bernama Inventory dengan mapping ke key 'i'

pada player.gd ditambahkan kode
```
func handle_inventory():
	if Input.is_action_just_pressed("inventory") and not inventory_on:
		$inventory.visible = true
		get_tree().paused=true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		inventory_on = true
	elif inventory_on:
		$inventory.visible = false
		get_tree().paused=false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		inventory_on = false
```
dan pada function _physics_process(delta) ditambahkan line berikut
```
handle_inventory()
```

dan juga disiapkan scene sebagai berikut
![image](https://github.com/KenKomKom/gamedev-tutorial-7/assets/119410845/2c6439e9-2c77-4777-bcf6-e9a4e292b2bb)
yang akan dimasukkan juga ke player.gd
lalu dibuat item_button.tscn yang memiliki kode
```
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
```
Untuk bisa mengeluarkan item di inventory ketika ditekan tombolnya

Selain itu,, diperlukan juga benda benda yang bisa dimasukkan ke dalam inventory. Maka Box.tscn dan objlamp.tscn diberikan kode yang membuatnya menjadi interactable. Dengan kode berikut
```
var dir_to_scene = "res://scenes/objlamp.tscn"
...
func interact():
	Inventorymanager.emit_signal("add_item", dir_to_scene, "lamp")
	self.queue_free()
```
Untuk objlamp.tscn
dan untuk Box.tscn ditambahkan kode
```
extends Interactable

var dir_to_scene = "res://scenes/Box.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func interact():
	Inventorymanager.emit_signal("add_item", dir_to_scene, "Box")
	self.queue_free()
```
## Implementasi level 2
Kemudian untuk level 2. Dibuat seperti level 1. Dibuat scene level2 terlebih dahulu, kemudian dibuat world2 dan pada world tersebut diberikan gscbox agar menjadi level. Untuk pelengkap, ditambahkan winscreen.tscn dengan struktur berikut
![image](https://github.com/KenKomKom/gamedev-tutorial-7/assets/119410845/06246e66-4bde-48e4-8a94-b5a161350735)
yang akan dipanggil ketika player berhasil menyelesaikan level 2.
