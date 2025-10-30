extends ProjBase

@export var delayedBuff: Resource

func _ready() -> void:
	movementDir = Vector2.RIGHT.rotated(rotation)



func enemy_hit(enemy: EnemyBase) -> void:
	enemy.damaged((damage + projLvl)*damageMult)
	var debuff = buff.instantiate()
	debuff.modLvl = projLvl
	enemy.add_child(debuff)
	debuff.apply_buff(0.0, enemy)
	var delayedDebuff = delayedBuff.instantiate()
	delayedDebuff.wait_time = debuff.timeLeft * (0.75 + 0.25 * projLvl)
	delayedDebuff.buffLvl = projLvl
	delayedDebuff.target = enemy
	enemy.add_child(delayedDebuff)
	queue_free()
