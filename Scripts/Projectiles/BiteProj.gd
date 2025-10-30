extends ProjBase

var enemiesHit = Array()

func _ready() -> void:
	scale *= 0.5 + 0.5*projLvl
	if scale.y > 0:
		movementDir = Vector2.DOWN.rotated(rotation)
	else:
		movementDir = Vector2.UP.rotated(rotation)

		
func enemy_hit(enemy: EnemyBase) -> void:
	if not enemiesHit.has(enemy):
		enemiesHit.append(enemy)
		enemy.damaged((damage + projLvl)*damageMult)
		var debuff = buff.instantiate()
		debuff.modLvl = projLvl
		enemy.add_child(debuff)
		debuff.apply_buff(0.0, enemy)
