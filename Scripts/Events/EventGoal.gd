extends Area2D

var requiredUnit

@export var finalGoal = true
@export var goalActive = true

var connectedEvent: EventBase

var nextGoal: Resource

func unit_check(unit) -> void:
	if unit == requiredUnit and goalActive:
		if finalGoal:
			connectedEvent.goal_met(unit)
		else:
			nextGoal.activate()
		queue_free()

func activate() -> void:
	goalActive = true
	modulate.a = 1
