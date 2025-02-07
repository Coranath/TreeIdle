# UNUSED! LEGACY CODE REVIEW ONLY!
#extends Node2D
#
#var angle = 90
#var growTimer
#var branch = preload("res://branch.tscn")
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#if Globals.growth:
		#add_to_group("branches")
		#add_to_group("Wood")
		#growTimer = Timer.new()
		#growTimer.autostart = true
		#growTimer.wait_time = Globals.WidthGrowthDelay  # Set the wait time to 5 seconds
		#growTimer.set_one_shot(false)  # Set to loop (repeating)
		#add_child(growTimer)
		#growTimer.start()  # Start the timer
		#
		#growTimer.timeout.connect(_increase_girth)
		#
		#await get_tree().create_timer(Globals.GrowDelay).timeout
		#sprout()
	#return
#
#func sprout() -> void:
	#var chance = randi_range(0,Globals.TotalBranchChance) #Branches to sprout
	#match chance:
		#_ when chance < Globals.SingleBranchChance:
			#new_branch()
		#_ when Globals.SingleBranchChance <= chance and chance < Globals.DoubleBranchChance:
			#print("sprouting 2")
			#new_branch(2)
		#_ when Globals.TripleBranchChance == chance:
			#print("sprouting 3")
			#new_branch(3)
	#remove_from_group("branches")
	#return
#
#func new_branch(number = 1) -> void:
	#for i in number:
		#var branch = branch.instantiate()
		#branch.position = self.global_position
		#branch.angle = angle
		#if number > 1:
			#branch.angle = angle + randi_range(-30,30)
		#branch.position.y -= 1 * sin(deg_to_rad(branch.angle))
		#branch.position.x += 1 * cos(deg_to_rad(branch.angle))
		#get_parent().add_child(branch)
	#return
#
#func _increase_girth() -> void:
	#if !Globals.growth:
		#growTimer.stop()
	#if self.scale < Globals.MaxWidth:
		#self.scale += Globals.WidthGrowth
	#else:
		#remove_from_group("Wood")
	#return
