class_name PlayerController
extends CharacterBody2D

var speed = 500

var expCount = 0.0
@export var levelExponent = 1.4
var level = 1

enum PrestigeOption {BASE, PRESTA, PRESTB}
enum CastState {AUTO, STANDARD, ADVANCED}

var Prestige = PrestigeOption.BASE
var CastMode = CastState.AUTO

var primAbilLvl = 1
var primCD = 0.0
@export var primTime = 5.0

var scndAbilLvl = 0
var scndCD = 0.0
@export var scndTime = 10.0

var tertAbilLvl = 0
var tertCD = 0.0
@export var tertTime = 8.0

var ultiAbilLvl = 0
var ultiCD = 0.0
@export var ultiTime = 60.0

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

	move_and_slide()
	
	
	if primAbilLvl > 0:
		primCD -= delta
		if CastMode == CastState.AUTO and primCD <= 0:
			primCD = primTime * 0.8
			primary_Ability(delta)
	
	if scndAbilLvl > 0:
		scndCD -= delta
		if CastMode == CastState.AUTO and scndCD <= 0:
			scndCD = scndTime * 0.8
			secondary_Ability(delta)
			
	if tertAbilLvl > 0:
		tertCD -= delta
		if CastMode == CastState.AUTO and tertCD <= 0:
			tertCD = tertTime * 0.8
			tertiary_Ability(delta)
			
	if ultiAbilLvl > 0:
		ultiCD -= delta
		if CastMode == CastState.AUTO and ultiCD <= 0:
			ultiCD = ultiTime * 0.8
			ultimate_Ability(delta)
			
func _process(_delta) -> void:
	HPBar.remove_point(1)
	HPBar.add_point(Vector2(60.0*HP/(maxHP+barrierHP), 0))
	BarrierHPBar.clear_points()
	BarrierHPBar.add_point(Vector2(60.0*HP/(maxHP+barrierHP), 0))
	BarrierHPBar.add_point(Vector2(60.0*HP/(maxHP+barrierHP) + 60.0*barrierHP/(maxHP+barrierHP), 0))
	var expRequired = 100.0 * pow(levelExponent, level-1)
	if expCount >= expRequired:
		expCount -= expRequired
		level_up()
			
		
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
	if level == 16:
		Prestige = PrestigeOption.PRESTA
		print("Huh? PlayerController is Evolving?")
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


func debug_barrier() -> void:
	barrierHP = 50.0
