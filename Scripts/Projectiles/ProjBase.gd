class_name ProjBase
extends Area2D

@export var duration = 5.0
@export var damage = 5.0
@export var buff: Resource

var damageMult = 1.0

var projLvl = 1.0

var movementDir = Vector2.ZERO
@export var speed = 100.0


func _physics_process(delta: float) -> void:
	var velocity = movementDir*speed*delta
	position += velocity
	duration -= delta
	if duration <= 0:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if GameManager.Players.has(body):
		player_hit(body)

func _on_area_entered(area: Area2D) -> void:
	if GameManager.Enemies.has(area):
		enemy_hit(area)
		
func player_hit(_player: PlayerController) -> void:
	pass
	
func enemy_hit(_enemy: EnemyBase) -> void:
	pass
