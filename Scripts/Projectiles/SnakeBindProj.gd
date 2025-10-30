extends ProjBase

@export var delayedBuff: Resource

@export var rotationSpeed = PI/5

func _ready() -> void:
	movementDir = Vector2.RIGHT.rotated(rotation)
	
func _process(delta: float) -> void:
	var closestTarget = null
	for i in GameManager.Enemies.size():
		if closestTarget == null:
			closestTarget = GameManager.Enemies[i]
		else:
			if position.distance_to(closestTarget.position) >= position.distance_to(GameManager.Enemies[i].position):
				closestTarget = GameManager.Enemies[i]
	if closestTarget != null:
		var targetAngle = (position - closestTarget.position).angle()
		if absf(angle_difference(rotation, targetAngle)) > PI/15:
			rotation -= clampf(angle_difference(rotation, targetAngle), -rotationSpeed * delta, rotationSpeed * delta)
			movementDir = Vector2.RIGHT.rotated(rotation)
		



func enemy_hit(enemy: EnemyBase) -> void:
	enemy.damaged((damage + projLvl)*damageMult)
	var debuff = buff.instantiate()
	debuff.modLvl = projLvl
	enemy.add_child(debuff)
	var addedTime = debuff.timeLeft
	debuff.apply_buff(0.0, enemy)
	if debuff.timeLeft > 0:
		var delayedDebuff = delayedBuff.instantiate()
		delayedDebuff.wait_time = debuff.timeLeft * (0.75 + 0.25 * projLvl)
		delayedDebuff.buffLvl = projLvl
		delayedDebuff.target = enemy
		enemy.add_child(delayedDebuff)
	else:
		enemy.find_child("ParalyzeTimer").wait_time += addedTime
	queue_free()
