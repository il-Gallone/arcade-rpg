extends Node

var currentWave = 0
var activeEvents = Array()


func spawn_event(event: EventBase):
	var newEvent = event.instantiate()
	activeEvents.append(newEvent)
	get_tree().root.add_child(newEvent)
