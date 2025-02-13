extends CharacterBody2D


const SPEED = 500.0


func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	move_and_slide()

	var zoomx = $Camera2D.zoom.x
	var zoomy = $Camera2D.zoom.y
	
	if Input.is_action_just_pressed("zoom_in"):
		zoomx += 0.1
		zoomy += 0.1
		
		if zoomx == 0:
			zoomx += 0.1
			zoomy += 0.1
		
		$Camera2D.zoom.x = zoomx
		$Camera2D.zoom.y = zoomy
		
		
	if Input.is_action_just_pressed("zoom_out"):
		zoomx -= 0.1
		zoomy -= 0.1
		
		if zoomx == 0:
			zoomx -= 0.1
			zoomy -= 0.1
		
		$Camera2D.zoom.x = zoomx
		$Camera2D.zoom.y = zoomy
