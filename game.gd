extends Node2D

var laser = preload("res://laser.xml")
var rock = preload("res://meteor.xml")
var laserCount = 0
var isShootPressed = false
var laserAr = []
var rockAr = []
var rockCount = 0
var timeSinceLastRock = 0
var score = 0
var gameRunning = true

func _ready():
	set_process(true)
	get_node("score").set_text(str(score))

func _process(delta):
	if gameRunning == true:
		game(delta)
	else:
		if Input.is_action_pressed("shoot"):
			restart()

func game(delta):
	if Input.is_action_pressed("shoot"):
		if isShootPressed == false:
			fire()
			isShootPressed = true
	else:
		isShootPressed = false

	var shipPos = get_node("ship").get_pos()

	if Input.is_action_pressed("ui_left"):
		shipPos.x = shipPos.x - 200 * delta

	if Input.is_action_pressed("ui_right"):
		shipPos.x = shipPos.x + 200 * delta

	get_node("ship").set_pos(shipPos)

	var laserId = 0
	for laser in laserAr:
		if laser != null:
			var laserPos = get_node(laser).get_pos()
			laserPos.y = laserPos.y - 300 * delta
			get_node(laser).set_pos(laserPos)
	
			if laserPos.y < 0:
				get_node(laser).queue_free()
				laserAr.remove(laserId)
			laserId = laserId + 1
			
	var rockId = 0
	for rock in rockAr:
		var rockPos = get_node(rock).get_pos()
		rockPos.y = rockPos.y + 200 * delta
		get_node(rock).set_pos(rockPos)

		if rockPos.y > 500:
			get_node(rock).queue_free()
			rockAr.remove(rockId)
		rockId += 1
		
	var laserId = 0
	for laser in laserAr:
		var rockId = 0
		for rocks in rockAr:
			var rockPos = get_node(rocks).get_pos()
			var laserPos = get_node(laser).get_pos()
			if laserPos.y < rockPos.y:
				if laserPos.x > rockPos.x - 15:
					if laserPos.x < rockPos.x + 15:
						get_node(rocks).queue_free()
						get_node(laser).queue_free()
						rockAr.remove(rockId)
						laserAr.remove(laserId)
						score += 1
						get_node("score").set_text(str(score))
						
			rockId += 1
		laserId += 1
	
	var rockId = 0
	for rockss in rockAr:
		var rockPos = get_node(rockss).get_pos()
		var shipPos = get_node("ship").get_pos()
		if rockPos.y > 450:
			if (rockPos.x - 15) < (shipPos.x + 40):
				if (rockPos.x +15) > (shipPos.x - 40):
					get_node("score").set_text("Crash!")
					gameRunning = false
			
	timeSinceLastRock = timeSinceLastRock + delta

	if timeSinceLastRock > 1:
		new_rock()
		timeSinceLastRock = 0

func fire():
	laserCount = laserCount + 1
	print("fire")
	var laser_inst = laser.instance()
	laser_inst.set_name("laser"+str(laserCount))
	add_child(laser_inst)
	var laserPos = get_node("laser"+str(laserCount)).get_pos()
	laserPos.y = 400
	var shipPos = get_node("ship").get_pos()
	laserPos.x = shipPos.x
	get_node("laser"+str(laserCount)).set_pos(laserPos)
	laserAr.push_back("laser"+str(laserCount))
	print(laserAr)


func new_rock():
	rockCount = rockCount + 1
	print("fire")
	var rock_inst = rock.instance()
	rock_inst.set_name("rock"+str(rockCount))
	add_child(rock_inst)
	var rockPos = get_node("rock"+str(rockCount)).get_pos()
	rockPos.y = - 5
	rockPos.x = rand_range(0, 320)
	get_node("rock"+str(rockCount)).set_pos(rockPos)
	rockAr.push_back("rock"+str(rockCount))
	print(rockAr)
	
func restart():
	var rockId = 0
	for rock in rockAr:
		get_node(rock).queue_free()
	rockAr.clear()
	for laser in laserAr:
		get_node(laser).queue_free()
	laserAr.clear()
	var shipPos = get_node("ship").get_pos()
	shipPos.x = 160
	get_node("ship").set_pos(shipPos)
	score = 0
	get_node("score").set_text(str(score))
	gameRunning = true
		
