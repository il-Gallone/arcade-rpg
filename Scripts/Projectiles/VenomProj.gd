extends ProjBase

func _ready() -> void:
	movementDir = Vector2.RIGHT.rotated(rotation)



func enemy_hit(enemy: EnemyBase) -> void:
	enemy.damaged((damage + projLvl)*damageMult)
	var debuff = buff.instantiate()
	debuff.modLvl = projLvl
	enemy.add_child(debuff)
	debuff.apply_buff(0.0, enemy)
	queue_free()
