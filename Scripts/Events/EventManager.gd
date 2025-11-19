extends Node

var activeEvents = Array()


func spawn_event(event):
	var newEvent = event.instantiate()
	get_tree().root.add_child(newEvent)
