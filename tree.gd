extends Node2D

#var root = preload("res://branch.tscn")
var branches = []
var oldGrowth = []


class Branch extends Node2D:
	var root: Vector2
	var length = 1
	var line: Line2D
	var angle
	var growing = true
	var sproutLikelihood = 0
	var width = 0.1
	
	func initialize(root: Vector2, angle = -PI/2): 
		self.root = root
		self.angle = angle
		self.line = Line2D.new()
		line.add_point(root)
		
		line.width_curve = Curve.new()
		line.width_curve.add_point(Vector2(0,0))
		line.width_curve.add_point(Vector2(1000,0))
		line.width_curve.set_point_right_tangent(0,-1)

		
	func grow():
		if self.growing:
			self.length += 1
			if len(line.points) > 1:
				line.remove_point(1)
			line.add_point(self.root + Vector2.RIGHT.rotated(angle)*self.length)
			self.sproutLikelihood += 1
		self.width += 0.0005
		line.width_curve.set_point_value(0, width)
		line.width_curve.set_point_value(1, width/4)
		
	func increase_girth():
		self.width += 0.01
		line.width_curve.set_point_value(0, width)
		line.width_curve.set_point_value(1, move_toward(line.width_curve.get_point_position(1).y, line.width_curve.get_point_position(0).y, 0.005))
#END OF BRANCH CLASS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var branch = Branch.new()
	branch.initialize(Vector2(550, 600))
	add_child(branch.line)
	branches.push_back(branch)
	
	var growTimer = Timer.new()
	growTimer.wait_time = Globals.GrowDelay
	growTimer.timeout.connect(_on_growTimer_timeout)
	add_child(growTimer)
	growTimer.start()
	
	return

func _on_growTimer_timeout() -> void:
	if len(branches) <= Globals.MaxNumberOfBranches:
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
		branch.root = root.root + Vector2.RIGHT.rotated(root.angle)*root.length

		branch.initialize(branch.root, branch.angle)
		add_child(branch.line)
		branches.push_back(branch)
		
	return
