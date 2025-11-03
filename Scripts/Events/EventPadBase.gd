class_name EventPad
extends Area2D

var prestigePad = false
var prestigePlayer: PlayerController

var padTime = 0.0
@export var padDuration = 1.0
@export var padSprite: Node

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
	padSprite.material.set_shader_parameter("line_thickness", 14.0*padTime/padDuration)
			
func _on_connected_object(object):
	if prestigePad:
		prestige_connection(object, true)
	elif object is PlayerController:
		padConnected = true
		
func _on_disconnected_object(object):
	if prestigePad:
		prestige_connection(object, false)
	elif object is PlayerController:
		padConnected = false
		
func prestige_connection(object, connecting: bool):
	if object == prestigePlayer:
		padConnected = connecting
