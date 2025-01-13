extends Node2D

var root = preload("res://branch.tscn")
var counter = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		var r = root.instantiate()
		r.position = Vector2(550, 600)
		add_child(r)

func _process(delta: float) -> void:
	if Globals.growth == true:
		if get_tree().get_node_count_in_group("branches") >= Globals.MaxNumberOfBranches:
			Globals.growth = false
		#if counter < Globals.GrowDelay:
			#counter += 1
		#else:
			#get_tree().call_group("branches", "_on_grow")
			#counter = 0
