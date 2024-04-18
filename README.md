## Implementasi sprint
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
