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
var target_pos = Vector2.ZERO
var target_distance = 0.0
var velocity = Vector2.ZERO
var velocityNudge = Vector2.ZERO
var collidingWithTarget = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HP = maxHP
	GameManager.Enemies.append(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	buffs_calc(delta)
	find_target()
	_unique_process(delta)
	if target != null:
		velocity = (target_pos - position).normalized()
		var overlapping_areas = get_overlapping_areas()
		velocityNudge = Vector2.ZERO
		for i in overlapping_areas.size():
			for j in GameManager.Enemies.size():
				if overlapping_areas[i] == GameManager.Enemies[j]:
					velocityNudge -= (GameManager.Enemies[j].position - position).normalized()*GameManager.Enemies[j].nudgeModifier/position.distance_to(GameManager.Enemies[j].position)			
		velocity += velocityNudge
		if collidingWithTarget:
			target.damaged(collisionDamage*delta*buffStats.damageMult)
	position += velocity * delta * speed * buffStats.speedMult
		
func _unique_process(_delta):
	if target != null:
		target_pos = target.position
	
func find_target():
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

func buffs_calc(delta) -> void:
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
		reset_buffStats()

func reset_buffStats() -> void:
	buffStats = BuffStats.new()
	if buffs.size() > 0:
		for i in buffs.size():
			calculate_mod_limits(buffs[i])
		calculate_buffs()

func calculate_mod_limits(buff) -> void:
	if buff.minSpdMod < buffStats.lowestMinSpd:
		buffStats.lowestMinSpd = buff.minSpdMod
	if buff.maxSpdMod > buffStats.highestMaxSpd:
		buffStats.highestMaxSpd = buff.maxSpdMod
	if buff.minDmgMod < buffStats.lowestMinDmg:
		buffStats.lowestMinDmg = buff.minDmgMod
	if buff.maxDmgMod > buffStats.highestMaxDmg:
		buffStats.lowestMaxDmg = buff.maxDmgMod
	if buff.minDefMod < buffStats.lowestMinDef:
		buffStats.lowestMinDef = buff.minDefMod
	if buff.maxDefMod > buffStats.highestMaxDef:
		buffStats.highestMaxDef = buff.maxDefMod
	if buff.minCDMod < buffStats.lowestMinCD:
		buffStats.lowestMinCD = buff.minCDMod
	if buff.maxCDMod > buffStats.highestMaxCD:
		buffStats.highestMaxCD = buff.maxCDMod
	if buff.minExpMod < buffStats.lowestMinExp:
		buffStats.lowestMinExp = buff.minExpMod
	if buff.maxExpMod > buffStats.highestMaxExp:
		buffStats.highestMaxExp = buff.maxExpMod
		
func calculate_buffs() -> void:
	for i in buffs.size():
		buffStats.speedMult += buffs[i].speedMod
		buffStats.damageMult += buffs[i].damageMod
		buffStats.defenseMult += buffs[i].defenseMod
		buffStats.CDMult += buffs[i].CDMod
		buffStats.expMult += buffs[i].expMod
	buffStats.speedMult = clampf(buffStats.speedMult, buffStats.lowestMinSpd, buffStats.highestMaxSpd)
	buffStats.damageMult = clampf(buffStats.damageMult, buffStats.lowestMinDmg, buffStats.highestMaxDmg)
	buffStats.defenseMult = clampf(buffStats.defenseMult, buffStats.lowestMinDef, buffStats.highestMaxDef)
	buffStats.CDMult = clampf(buffStats.CDMult, buffStats.lowestMinCD, buffStats.highestMaxCD)
	buffStats.expMult = clampf(buffStats.expMult, buffStats.lowestMinExp, buffStats.highestMaxExp)

func _on_body_entered(body: Node2D) -> void:
	if body == target:
		collidingWithTarget = true


func _on_body_exited(body: Node2D) -> void:
	if body == target:
		collidingWithTarget = false
