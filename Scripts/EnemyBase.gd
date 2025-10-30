class_name EnemyBase
extends Area2D

@export var XP_Crystal: Resource
@export var expValue = 5

@export var maxHP = 100.0
var HP = 100.0
var barrierHP = 0.0
@export var speed = 100.0
@export var nudgeModifier = 2

@export var collisionDamage = 3.0

var buffStats = BuffStats.new()
var buffs = Array()
var expiredBuffs = Array()

var target
var target_distance = 0.0
var velocity
var velocityNudge = Vector2.ZERO
var collidingWithTarget = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HP = maxHP
	GameManager.Enemies.append(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if buffs.size() > 0:
		for i in buffs.size():
			buffs[i].apply_buff(delta, self)
			if buffs[i].timeLeft <= 0:
				expiredBuffs.append(buffs[i])
	if expiredBuffs.size() > 0:
		for i in expiredBuffs.size():
			buffs.erase(expiredBuffs[i])
			expiredBuffs[i].queue_free()
		expiredBuffs.clear()
	for i in GameManager.Players.size():
		if target == null:
			target = GameManager.Players[i]
			target_distance = target.position.distance_to(position)
		else:
			target_distance = target.position.distance_to(position)
			if target != GameManager.Players[i]:
				var compare_distance = GameManager.Players[i].positon.distance_to(position)
				if compare_distance < target_distance:
					target = GameManager.Players[i]
	if target != null:
		velocity = (target.position - position).normalized()
		var overlapping_areas = get_overlapping_areas()
		velocityNudge = Vector2.ZERO
		for i in overlapping_areas.size():
			for j in GameManager.Enemies.size():
				if overlapping_areas[i] == GameManager.Enemies[j]:
					velocityNudge -= (GameManager.Enemies[j].position - position).normalized()*GameManager.Enemies[j].nudgeModifier/position.distance_to(GameManager.Enemies[j].position)			
		velocity += velocityNudge
		position += velocity * delta * speed * buffStats.speedMult
		if collidingWithTarget:
			target.damaged(collisionDamage*delta*buffStats.damageMult)
		
func damaged(damageReceived: float):
	if damageReceived > 0:
		@warning_ignore("standalone_expression")
		damageReceived / buffStats.defenseMult
		if barrierHP > 0:
			if barrierHP < damageReceived:
				damageReceived -= barrierHP
				barrierHP = 0
			else:
				barrierHP -= damageReceived
				damageReceived = 0
	if damageReceived != 0:
		HP -= damageReceived
		if HP > maxHP:
			HP = maxHP
		if HP <= 0:
			death()
			
	
func death() -> void:
	GameManager.Enemies.erase(self)
	var xpDrop = XP_Crystal.instantiate()
	xpDrop.position = position
	xpDrop.expValue = expValue
	get_tree().root.call_deferred("add_child", xpDrop)
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body == target:
		collidingWithTarget = true


func _on_body_exited(body: Node2D) -> void:
	if body == target:
		collidingWithTarget = false
