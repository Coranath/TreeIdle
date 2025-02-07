extends Node2D

#var root = preload("res://branch.tscn")
var branches = []
var oldGrowth = []
var masterWidthCurve = Curve.new()
var masterWidth = 0.2
var masterLength = 0


class Branch extends Node2D:
	var root: Vector2
	var totalLength: float # Length of tree minus this branch
	var length = 0.0
	var line: Line2D
	var angle
	var growing = true
	var sproutLikelihood = 0
	var width = 0.1
	var copyMWC: Curve
	
	
	""" 
	Need to have end of branches be set to equal their length as a
	percentage of the master width, that way the trunk will continue
	to grow in synce as it will be 1/3 the way down the curve then
	as the tree grow, 1/5 the way day and so on!
	"""
	
	func initialize(rootP: Vector2, masterWidthCurve: Curve, angleP = -PI/2, totalLengthP = 0): 
		root = rootP
		totalLength = totalLengthP
		copyMWC = masterWidthCurve
		angle = angleP
		line = Line2D.new()
		line.width = 10
		line.add_point(root)
		line.begin_cap_mode = Line2D.LINE_CAP_ROUND
		
		line.width_curve = Curve.new()
		line.width_curve.add_point(Vector2(0, copyMWC.sample(totalLength)))
		line.width_curve.add_point(Vector2(1, copyMWC.sample(totalLength + length)))
		# TODO The problem is that the width_curve is not increasing the size of the tip!
		# The tip of the line is always equal to 0, and the base is always larger.
		# It's not like my original where the whole thing grows!
		# Maybe increasing tip and tail growth but that would make largness appear immediately at the tip!? UGH!

		
	func grow():
		if growing:
			length += 0.0001
			if len(line.points) > 1:
				line.remove_point(1)
			line.add_point(root + Vector2.RIGHT.rotated(angle)*length*10000)
			sproutLikelihood += 1
		line.width_curve.set_point_value(0, copyMWC.sample(totalLength))
		line.width_curve.set_point_value(1, copyMWC.sample(totalLength+length))
		#print("Sample at rootLength ", copyMWC.sample(rootLength))
		#line.width_curve.remove_point(1)
		#line.width_curve.add_point(Vector2(length, 0))
		
	func increase_girth():
		line.width_curve.set_point_value(0, copyMWC.sample(totalLength))
		line.width_curve.set_point_value(1, copyMWC.sample(length+totalLength))
		pass
#END OF BRANCH CLASS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var branch = Branch.new()
	branch.initialize(Vector2(550, 600), masterWidthCurve)
	add_child(branch.line)
	branches.push_back(branch)
	
	var growTimer = Timer.new()
	growTimer.wait_time = Globals.GrowDelay
	growTimer.timeout.connect(_on_growTimer_timeout)
	add_child(growTimer)
	growTimer.start()
	
	#masterWidthCurve.max_value = 100000 # This only affects the Y axis
	masterWidthCurve.add_point(Vector2(0,0))
	masterWidthCurve.add_point(Vector2(1,0))
	
	return

func _on_growTimer_timeout() -> void:
	if len(branches) <= Globals.MaxNumberOfBranches:
		masterLength += 0.0001
		masterWidth += 0.005
		masterWidthCurve.set_point_value(0, masterWidth)
		masterWidthCurve.remove_point(1)
		masterWidthCurve.add_point(Vector2(masterLength,0.1))
		#print("second point = ", masterWidthCurve.get_point_position(1))
		#print("master length = ", masterLength)
		
		for branch in branches:
			var chance = randi_range(0,Globals.TotalBranchChance) # Chance for ranches to sprout
			match chance:
				_ when chance < Globals.SingleBranchChance - branch.sproutLikelihood:
					branch.grow()
				_ when Globals.SingleBranchChance - branch.sproutLikelihood <= chance and chance < Globals.DoubleBranchChance + branch.sproutLikelihood:
					print("sprouting 2")
					new_branch(2, branch)
				_ when Globals.DoubleBranchChance <= chance:
					print("sprouting 3")
					new_branch(3, branch)
		for wood in oldGrowth:
			wood.increase_girth()
			
	return

func new_branch(number, root) -> void:
	root.growing = false
	branches.remove_at(branches.find(root))
	oldGrowth.push_back(root)
	for i in number:
		var branch = Branch.new()
		branch.angle = root.angle + deg_to_rad(randi_range(-30, 30))
		branch.root = root.root + Vector2.RIGHT.rotated(root.angle)*root.length*10000

		branch.initialize(branch.root, masterWidthCurve, branch.angle, root.length+root.totalLength)
		add_child(branch.line)
		branches.push_back(branch)
		
	return
