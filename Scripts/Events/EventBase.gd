class_name EventBase
extends Node

@export var eventEnemy: Resource
@export var numOfEnemies: int

var goalsMet = 0

@export var autoStart = true
@export var eventPad: Resource
@export var minimumWave: int

@export var prestiveEvent = false
var prestigePlayer: PlayerController

@export var timedEvent = true
@export var eventDuration: float

var eventStarted = false
var padSpawned = false
var linkedPads = Array()
@export var spawnLocation: Vector2

func _ready() -> void:
	if minimumWave >= GameManager.enemyWave && autoStart:
		start_event()
	elif minimumWave >= GameManager.enemyWave:
		spawn_event_pad()
		
func _process(delta: float) -> void:
	if eventStarted:
		if timedEvent:
			eventDuration -= delta
			if eventDuration <= 0:
				event_condition_timer()
		if numOfEnemies <= 0:
			event_condition_enemies()
	else:
		if minimumWave >= GameManager.enemyWave:
			if autoStart:
				start_event()
			elif not padSpawned:
				spawn_event_pad()
			else:
				var padsActivated = true
				for i in linkedPads.size():
					if linkedPads[i].padTime < linkedPads[i].padDuration:
						padsActivated = false
				if padsActivated:
					start_event()
					clear_pads()
		
func start_event() -> void:
	EventManager.activeEvents.append(self)
	if numOfEnemies > 0:
		for i in range(numOfEnemies):
			var new_enemy
			new_enemy = eventEnemy.instantiate()
			new_enemy.position = EnemyManager.generate_enemy_position()
			EnemyManager.wave_buff(new_enemy)
			new_enemy.eventEnemy = true
			new_enemy.connectedEvent = self
			get_tree().root.add_child(new_enemy)
	eventStarted = true
	
func spawn_event_pad() -> void:
	padSpawned = true
	if prestiveEvent:
		var padSpawner = eventPad.instantiate()
		padSpawner.prestigePad = true
		padSpawner.prestigePlayer = prestigePlayer
		padSpawner.position = spawnLocation
		linkedPads.append(padSpawner)
		get_tree().root.add_child(padSpawner)
	else:
		for i in GameManager.Players.size():
			var padSpawner = eventPad.instantiate()
			padSpawner.prestigePad = false
			padSpawner.position = spawnLocation + Vector2(0, 60*(GameManager.Players.size()-1)).rotated(2*PI/GameManager.Players.size()*i)
			linkedPads.append(padSpawner)
			get_tree().root.add_child(padSpawner)
			
func clear_pads() -> void:
	for i in linkedPads.size():
		linkedPads[i].queue_free()
			
func goal_met(_unit):
	pass

func event_condition_timer():
	pass
	
func event_condition_enemies():
	pass
	
func event_condition_unique():
	pass
