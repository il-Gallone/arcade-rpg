extends ProjBase

@export var delayedBuff: Resource
@export var buffImmunity: Resource

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
	var ignoreDebuff = false
	for i in enemy.buffs.size():
		if enemy.buffs[i].BuffID == "ConstrictImmune":
			ignoreDebuff = true
	if not ignoreDebuff:
		var debuff = buff.instantiate()
		debuff.modLvl = projLvl
		enemy.add_child(debuff)
		debuff.apply_buff(0.0, enemy)
		var buffImm = buffImmunity.instantiate()
		buffImm.modLvl = projLvl
		enemy.add_child(buffImm)
		buffImm.apply_buff(0.0, enemy)
		var delayedDebuff = delayedBuff.instantiate()
		delayedDebuff.wait_time = 0.01 + debuff.timeLeft * (0.75 + 0.25 * projLvl)
		delayedDebuff.buffLvl = projLvl
		delayedDebuff.target = enemy
		enemy.add_child(delayedDebuff)
	queue_free()
