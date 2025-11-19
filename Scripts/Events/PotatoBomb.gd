extends EnemyBase

@export var explosion: Resource
@export var desiredRange = 50.0

@export var targetGoal: Resource
@export var goalRange = 1000.0

@export var blink: Sprite2D

var blinkTime = 0.0
var blinkRate = 4

var receivedDamage = 0.0

func find_target():
	if target == null:
		var playerNum = 0
		for i in GameManager.Players.size():
			if i == 0:
				target = GameManager.Players[i]
				target_distance = target.position.distance_to(position)
			else:
				target_distance = target.position.distance_to(position)
				if target != GameManager.Players[i]:
					var compare_distance = GameManager.Players[i].positon.distance_to(position)
					if compare_distance < target_distance:
						target = GameManager.Players[i]
						playerNum = i
		var goal = targetGoal.instantiate()
		goal.position = position + (target.position - position).normalized() * goalRange
		goal.requiredUnit = self
		goal.connectedEvent = connectedEvent
		match playerNum:
			0:
				goal.modulate = Color.BLUE
			1:
				goal.modulate = Color.RED
			2:
				goal.modulate = Color.YELLOW
			3:
				goal.modulate = Color.GREEN
		get_tree().root.add_child(goal)
	else:
		target_distance = target.position.distance_to(position)
		

func _unique_process(delta):
	if target != null:
		if target_distance > desiredRange:
			target_pos = target.position
			speed = target.speed
		else:
			target_pos = position
	blinkTime += delta
	if blinkTime >= connectedEvent.eventDuration / blinkRate:
		blinkTime -= connectedEvent.eventDuration / blinkRate
		blink.visible = !blink.visible
	damaged(receivedDamage*delta/2)
		
func death() -> void:
	target.damaged(collisionDamage)
	GameManager.Enemies.erase(self)
	connectedEvent.numOfEnemies -= 1
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if GameManager.Enemies.has(area):
		receivedDamage += area.collisionDamage*area.buffStats.damageMult*area.buffStats.waveMult


func _on_area_exited(area: Area2D) -> void:
	if GameManager.Enemies.has(area):
		receivedDamage -= area.collisionDamage*area.buffStats.damageMult*area.buffStats.waveMult
