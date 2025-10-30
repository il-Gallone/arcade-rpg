extends Timer

@export var buff: Resource

var target
var buffLvl = 1


func _on_timeout() -> void:
	if target != null:
		var buffApp = buff.instantiate()
		buffApp.modLvl = buffLvl
		target.add_child(buffApp)
		buffApp.apply_buff(0.0, target)
	queue_free()
