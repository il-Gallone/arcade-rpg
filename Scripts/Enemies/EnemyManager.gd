extends Node

@export var Debug_Baddie: Resource
@export var Debug_Rangie: Resource
@export var Debug_Elite: Resource


func debug_spawn() -> void:
	if GameManager.Enemies.size() >= GameManager.maxEnemies:
		var furthestEnemy = 0
		for i in GameManager.Enemies.size():
			if GameManager.Enemies[furthestEnemy] != GameManager.Enemies[i]:
				if GameManager.Enemies[furthestEnemy].target_distance < GameManager.Enemies[i].target_distance:
					furthestEnemy = i
		GameManager.Enemies[furthestEnemy].global_position = generate_enemy_position()
	else:
		var new_enemy
		if randf_range(0, 10) > 8:
			new_enemy = Debug_Rangie.instantiate()
		else:
			new_enemy = Debug_Baddie.instantiate()
		new_enemy.position = generate_enemy_position()
		get_tree().root.add_child(new_enemy)
func debug_spawn_elite() -> void:
	var new_enemy = Debug_Elite.instantiate()
	new_enemy.position = generate_enemy_position()
	get_tree().root.add_child(new_enemy)

func generate_enemy_position() -> Vector2:
	var minX = null
	var maxX = null
	var minY = null
	var maxY = null
	for i in GameManager.Players.size():
		if minX == null:
			minX = GameManager.Players[i].position.x
		if GameManager.Players[i].position.x < minX:
			minX = GameManager.Players[i].position.x
		if maxX == null:
			maxX = GameManager.Players[i].position.x
		if GameManager.Players[i].position.x > maxX:
			maxX = GameManager.Players[i].position.x
		if minY == null:
			minY = GameManager.Players[i].position.y
		if GameManager.Players[i].position.y < minY:
			minY = GameManager.Players[i].position.y
		if maxY == null:
			maxY = GameManager.Players[i].position.y
		if GameManager.Players[i].position.x < maxY:
			maxY = GameManager.Players[i].position.y
	var spawnAngle = randf_range(0, PI*2)
	var spawnDirection = Vector2.UP.rotated(spawnAngle)
	var screenSize = DisplayServer.screen_get_size()
	var spawnPosition = Vector2(spawnDirection.x * (screenSize.x/2 + 100), spawnDirection.y * (screenSize.y/2 + 100))
	if spawnPosition.x <= 0:
		spawnPosition.x += minX
	elif spawnPosition.x > 0:
		spawnPosition.x += maxX
	if spawnPosition.y <= 0:
		spawnPosition.y += minY
	elif spawnPosition.y > 0:
		spawnPosition.y += maxY
	return spawnPosition
	
	
