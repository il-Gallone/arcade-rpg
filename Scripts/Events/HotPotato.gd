extends EventBase

@export var kaboom: Resource
		
func start_event() -> void:
	EventManager.activeEvents.append(self)
	if numOfEnemies > 0:
		for i in range(numOfEnemies * GameManager.Players.size()):
			var new_enemy
			new_enemy = eventEnemy.instantiate()
			new_enemy.position = spawnLocation +  Vector2(0, 10 + 40*(GameManager.Players.size()-1)).rotated(2*PI/GameManager.Players.size()*i)
			EnemyManager.wave_buff(new_enemy)
			new_enemy.eventEnemy = true
			new_enemy.connectedEvent = self
			get_tree().root.add_child(new_enemy)
	eventStarted = true

func goal_met(unit) -> void:
	goalsMet += 1
	numOfEnemies -= 1
	GameManager.Enemies.erase(unit)
	unit.queue_free()

func event_condition_timer():
	var leftoverPotatoes = Array()
	for i in GameManager.Enemies.size():
		if GameManager.Enemies[i].connectedEvent == self:
			leftoverPotatoes.append(GameManager.Enemies[i])
	for i in leftoverPotatoes.size():
		leftoverPotatoes[i].death()
	
	
func event_condition_enemies():
	var damagePercent = (50.0/GameManager.Players.size())*goalsMet
	var buff = kaboom.instantiate()
	buff.damagePercent = damagePercent
	GameManager.waveModifer = buff
	GameManager.modiferWaves = 1
