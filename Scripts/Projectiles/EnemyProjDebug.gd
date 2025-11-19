extends ProjBase


func _ready() -> void:
	movementDir = Vector2.RIGHT.rotated(rotation)
	for child in get_children():
		child.rotation = rotation
	rotation = 0


func player_hit(player: PlayerController) -> void:
	player.damaged(damage * damageMult)
	queue_free()

func enemy_hit(escort: EnemyBase) ->  void:
	escort.damaged(damage * damageMult)
	queue_free()
