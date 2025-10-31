extends PlayerController

@export var biteAttack: Resource
@export var spitAttack: Resource

@export var snakeAttack: Resource

@export var gazeAttack: Resource

func find_target() -> Node2D:
	var target = null
	for i in GameManager.Enemies.size():
		if target == null:
			target = GameManager.Enemies[i]
		else:
			if target != GameManager.Enemies[i]:
				var compare_distance = GameManager.Enemies[i].position.distance_to(position)
				var target_distance = target.position.distance_to(position)
				if compare_distance < target_distance:
					target = GameManager.Enemies[i]
	return target
		
func _hero_process(_delta: float) -> void:
	if GameManager.Enemies.size() > 0:
		var target = find_target()
		var target_distance = position.distance_to(target.position)
		if target_distance <= 100.0:
			primAbilAltMode = true
		else:
			primAbilAltMode = false

func primary_Ability(_delta: float) -> void:
	if GameManager.Enemies.size() > 0:
		var target = find_target()
		var target_distance = position.distance_to(target.position)
		if target_distance <= 100.0:
			var bite = biteAttack.instantiate()
			bite.position = (target.position - position).normalized() * 50
			bite.rotation = position.angle_to_point(target.position)
			if bite.rotation > PI/2 || bite.rotation <= -PI/2:
				bite.scale.y -= 2
			bite.projLvl = primAbilLvl
			bite.damageMult = buffStats.damageMult
			add_child(bite)
		else:
			@warning_ignore("integer_division")
			var spitNum = max((primAbilLvl+1)/2, 1)
			for i in range(spitNum):
				var spit = spitAttack.instantiate()
				spit.position = position + (target.position - position).normalized() * 50
				spit.rotation = position.angle_to_point(target.position) - (PI/24*(spitNum-1)) + (PI/12)*(i)
				spit.projLvl = primAbilLvl
				spit.damageMult = buffStats.damageMult
				get_tree().root.add_child(spit)
		print("Primary Executed at Level: ", primAbilLvl)
	else:
		print("Primary Failed to Execute")
		primCD = 0.2

func secondary_Ability(_delta: float) -> void:
	for i in range(3+scndAbilLvl):
		var astralSnake = snakeAttack.instantiate()
		astralSnake.rotation = (i * PI * 2 / (3+scndAbilLvl)) - (PI/2)
		astralSnake.position = position + Vector2.RIGHT.rotated(astralSnake.rotation) * 50
		astralSnake.damageMult = buffStats.damageMult
		get_tree().root.add_child(astralSnake)
	print("Secondary Executed at Level: ", scndAbilLvl)
	
func tertiary_Ability(_delta: float) -> void:
	var gaze = gazeAttack.instantiate()
	gaze.scale *= 0.875 + 0.125*tertAbilLvl
	gaze.projLvl = tertAbilLvl
	add_child(gaze)
