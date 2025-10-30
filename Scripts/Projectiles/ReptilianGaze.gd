extends ProjBase


var enemiesHit = Array()

func _process(_delta: float) -> void:
	$"./Sprite2D".modulate.a = duration*2

		
func player_hit(player: PlayerController) -> void:
	if player.buffs.size() > 0:
		for i in player.buffs.size():
			if player.buffs[i].Debuff:
				player.buffs[i].timeLeft = 0.0
	var regen = buff.instantiate()
	regen.modLvl = projLvl
	player.add_child(regen)
	regen.apply_buff(0.0, player)
	
	
func enemy_hit(enemy: EnemyBase) -> void:
	if not enemiesHit.has(enemy):
		enemiesHit.append(enemy)
		if enemy.buffs.size() > 0:
			for i in enemy.buffs.size():
				if not enemy.buffs[i].Debuff:
					if enemy.buffs[i].BuffID.contains("Strong"):
						enemy.buffs[i].timeLeft += 4.0 + projLvl
					else:
						enemy.buffs[i].strengthen_buff(projLvl, enemy)
						
