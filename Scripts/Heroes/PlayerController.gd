class_name PlayerController
extends CharacterBody2D

var speed = 500

var expCount = 0.0
var expRequired = 100
@export var levelExponent = 1.4
var level = 1
@export var prestigeEvent: EventBase

enum PrestigeOption {BASE, PRESTA, PRESTB}
enum CastState {AUTO, STANDARD, ADVANCED}

var Prestige = PrestigeOption.BASE
var CastMode = CastState.AUTO

var primAbilLvl = 1
var primCD = 0.0
@export var primTime = 5.0
var primAbilAltMode = false

var scndAbilLvl = 0
var scndCD = 0.0
@export var scndTime = 10.0
var scndAbilAltMode = false

var tertAbilLvl = 0
var tertCD = 0.0
@export var tertTime = 8.0
var tertAbilAltMode = false

var ultiAbilLvl = 0
var ultiCD = 0.0
@export var ultiTime = 60.0
var ultiAbilAltMode = false

var pickupMag = 250.0

var maxHP = 100.0
var HP = 100.0
var barrierHP = 0.0
@export var HPBar: Line2D
@export var BarrierHPBar: Line2D
var buffStats = BuffStats.new()
var buffs = Array()
var expiredBuffs = Array()

func _ready() -> void:
	GameManager.Players.append(self)
	if CastMode == CastState.AUTO:
		buffStats.CDMult = 0.8
		buffStats.lowestMinCD = 0.8
		buffStats.highestMaxCD = 0.8
	
	

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
			
	var direction := Input.get_vector("left", "right", "up", "down")
	velocity = direction.normalized() * speed * buffStats.speedMult
	_hero_process(delta)
	move_and_slide()
	
	
	if primAbilLvl > 0:
		primCD -= delta
		if CastMode == CastState.AUTO and primCD <= 0:
			primCD = primTime * buffStats.CDMult
			primary_Ability(delta)
	
	if scndAbilLvl > 0:
		scndCD -= delta
		if CastMode == CastState.AUTO and scndCD <= 0:
			scndCD = scndTime * buffStats.CDMult
			secondary_Ability(delta)
			
	if tertAbilLvl > 0:
		tertCD -= delta
		if CastMode == CastState.AUTO and tertCD <= 0:
			tertCD = tertTime * buffStats.CDMult
			tertiary_Ability(delta)
			
	if ultiAbilLvl > 0:
		ultiCD -= delta
		if CastMode == CastState.AUTO and ultiCD <= 0:
			ultiCD = ultiTime * buffStats.CDMult
			ultimate_Ability(delta)
			
func _process(_delta: float) -> void:
	HPBar.remove_point(1)
	HPBar.add_point(Vector2(60.0*HP/(maxHP+barrierHP), 0))
	BarrierHPBar.clear_points()
	BarrierHPBar.add_point(Vector2(60.0*HP/(maxHP+barrierHP), 0))
	BarrierHPBar.add_point(Vector2(60.0*HP/(maxHP+barrierHP) + 60.0*barrierHP/(maxHP+barrierHP), 0))
	if expCount >= expRequired && expRequired != -1:
		expCount -= expRequired
		level_up()
		
func _hero_process(_delta: float) -> void:
	pass
		
func primary_Ability(_delta: float) -> void:
	print("Primary Executed at Level: ", primAbilLvl)
	
func secondary_Ability(_delta: float) -> void:
	print("Secondary Executed at Level: ", scndAbilLvl)
	
func tertiary_Ability(_delta: float) -> void:
	print("Tertiary Executed at Level: ", tertAbilLvl)
	
func ultimate_Ability(_delta: float) -> void:
	print("Ultimate Executed at Level: ", ultiAbilLvl , " WOAH!!!")

func level_up() -> void:
	level += 1
	expRequired = 100.0 * pow(levelExponent, level-1)
	#if level == 16:
		#level -= 1
		#expRequired = -1
		#EventManager.spawn_event(prestigeEvent)
	if Prestige == PrestigeOption.BASE:
		if primAbilLvl * 3 < level:
			primAbilLvl += 1
		if scndAbilLvl * 3 + 1 < level:
			scndAbilLvl += 1
		if tertAbilLvl * 3 + 2 < level:
			tertAbilLvl += 1
		print("Level Up! Current Level: ", level)
	else:
		if level < 28:
			if ultiAbilLvl*4 + 15 < level:
				ultiAbilLvl += 1
			if (primAbilLvl-5)*4 + 16 < level:
				primAbilLvl += 1
			if (scndAbilLvl-5)*4 + 17 < level:
				scndAbilLvl += 1
			if (tertAbilLvl-5)*4 + 18 < level:
				tertAbilLvl += 1
			print("Level Up! Current Prestige Level: ", (level - 15))
		else:
			print("OVERLEVELING!")
			
			
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
			player_down()
			
func player_down() -> void:
	print("Player Died, HURK BLEH!!!:")
	HP = maxHP
	print("Debug Resurrection Applied")
	
	
func reset_buffStats() -> void:
	buffStats = BuffStats.new()
	if CastMode == CastState.AUTO:
		buffStats.CDMult = 0.8
		buffStats.lowestMinCD = 0.8
		buffStats.highestMaxCD = 0.8
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
	clampf(buffStats.speedMult, buffStats.lowestMinSpd, buffStats.highestMaxSpd)
	clampf(buffStats.damageMult, buffStats.lowestMinDmg, buffStats.highestMaxDmg)
	clampf(buffStats.defenseMult, buffStats.lowestMinDef, buffStats.highestMaxDef)
	clampf(buffStats.CDMult, buffStats.lowestMinCD, buffStats.highestMaxCD)
	clampf(buffStats.expMult, buffStats.lowestMinExp, buffStats.highestMaxExp)
func debug_barrier() -> void:
	barrierHP = 50.0
