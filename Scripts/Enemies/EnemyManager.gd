class_name EnemyManager
extends Node

@export var Debug_Baddie: Resource
@export var Debug_Rangie: Resource
@export var Debug_Elite: Resource

@export var Hot_Potato: Resource


var waveTimer = 0.0


	
func _process(delta: float) -> void:
	waveTimer += delta
	if waveTimer >= 10.0 + GameManager.enemyWave*5.0 || GameManager.Enemies.size() == 0:
		wave_spawn()


func wave_spawn() -> void:
	GameManager.enemyWave += 1
	if GameManager.enemyWave == 4:
		EventManager.spawn_event(Hot_Potato)
	waveTimer = 0.0
	var numEnemies = 8 + (GameManager.enemyWave-1)*4 * GameManager.Players.size()
	for i in range(numEnemies):
		if GameManager.Enemies.size() >= GameManager.maxEnemies:
			var furthestEnemy = 0
			for j in GameManager.Enemies.size():
				if GameManager.Enemies[furthestEnemy] != GameManager.Enemies[j]:
					if GameManager.Enemies[furthestEnemy].target_distance < GameManager.Enemies[j].target_distance:
						furthestEnemy = j
			GameManager.Enemies[furthestEnemy].global_position = generate_enemy_position()
			wave_buff(GameManager.Enemies[furthestEnemy])
		else:
			if i < 8 * GameManager.Players.size():
				spawn()
			elif i < 20 * GameManager.Players.size():
				if pow(-1, i) < 0:
					spawn_rangie()
				else:
					spawn()
			else:
				if pow(-1, i) < 0:
					@warning_ignore("integer_division")
					if pow(-1, i/4) < 0:
						spawn_elite()
					else:
						spawn_rangie()
				else:
					spawn()
				

static func wave_buff(enemy: EnemyBase) -> void:
	enemy.maxHP *= pow(1.2, GameManager.enemyWave-1)
	enemy.HP  *= pow(1.2, GameManager.enemyWave--1)
	enemy.buffStats.waveMult = pow(1.2, GameManager.enemyWave--1)
	if GameManager.modiferWaves > 0:
		var buff = GameManager.waveModifer.duplicate()
		enemy.add_child(buff)
		buff.apply_buff(0.0, enemy)
	
func debug_spawn() -> void:
	var type = randf_range(0, 20)
	if type < 15:
		spawn()
	elif type < 18:
		spawn_rangie()
	else:
		spawn_elite()
	if GameManager.Enemies.size() > GameManager.maxEnemies:
		print("Over Enemy Limit, Stop Manual Spawning!")
	elif GameManager.Enemies.size() >= GameManager.maxEnemies - 10:
		print("Approaching Enemy Limit, May Cause Lag")

func spawn() -> void:
	var new_enemy
	new_enemy = Debug_Baddie.instantiate()
	new_enemy.position = generate_enemy_position()
	wave_buff(new_enemy)
	get_tree().root.add_child(new_enemy)

func spawn_rangie() -> void:
	var new_enemy = Debug_Rangie.instantiate()
	new_enemy.position = generate_enemy_position()
	wave_buff(new_enemy)
	get_tree().root.add_child(new_enemy)
		
func spawn_elite() -> void:
	var new_enemy = Debug_Elite.instantiate()
	new_enemy.position = generate_enemy_position()
	wave_buff(new_enemy)
	get_tree().root.add_child(new_enemy)

static func generate_enemy_position() -> Vector2:
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
	
	
