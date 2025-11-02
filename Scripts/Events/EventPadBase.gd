class_name EventPad
extends Area2D

var prestigePad = false
var prestigePlayer: PlayerController

var padTime = 0.0
@export var padDuration = 3.0

var padConnected = false

func _physics_process(delta: float) -> void:
	if padConnected:
		padTime += delta
		if padTime >= padDuration:
			padTime = padDuration
	else:
		padTime -= delta/2
		if padTime < 0:
			padTime = 0
			
			
func _on_connected_object(object: PhysicsBody2D):
	if prestigePad:
		prestige_connection(object, true)
	else:
		padConnected = true
		
func _on_disconnected_object(object: PhysicsBody2D):
	if prestigePad:
		prestige_connection(object, false)
	else:
		padConnected = false
		
func prestige_connection(object: PhysicsBody2D, connecting: bool):
	if object == prestigePlayer:
		padConnected = connecting
