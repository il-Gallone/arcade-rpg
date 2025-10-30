class_name PickupBase
extends Area2D

var target
var velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	for i in GameManager.Players.size():
		if target == null:
			target = GameManager.Players[i]
		else:
			if target != GameManager.Players[i]:
				var compare_distance = GameManager.Players[i].positon.distance_to(position)
				var target_distance = target.position.distance_to(position)
				if compare_distance < target_distance:
					target = GameManager.Players[i]
	if target != null:
		if target.pickupMag >= position.distance_to(target.position):
			velocity = (target.position - position).normalized() * 10000/position.distance_to(target.position)
			position += velocity * delta
					
					
					
func _on_body_entered(body: Node2D) -> void:
	if body == target:
		player_pickup()
		
func player_pickup():
	queue_free()
	#run pickup functions
