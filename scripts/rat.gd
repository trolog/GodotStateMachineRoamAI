extends AnimatedSprite

onready var ground_ray = $ground_ray
onready var wall_ray = $wall_ray

var max_fall_speed = 4
var current_fall_speed = 0
var move_speed_fall = 1
var move_speed = 2

enum state {running,
idle,
falling
}

var rat_state = state.running

func _ready():
	enter_state(state.running)
	pass 
	
func _physics_process(delta):
	process_states()
	pass
	
func enter_state(pass_state):
	if(rat_state != pass_state):
		leave_state(rat_state)
		rat_state = pass_state
		
	if(pass_state == state.running):
		play("run")
		$Timer.start(rand_range(0.5,1.5))
		
	if(pass_state == state.idle):
		if(rand_range(0,2) > 1):
			play("idleclean")
		else:
			play("idlestand")

func process_states():
	if(rat_state == state.falling):
		process_falling()
	if(rat_state == state.running):
		process_running()
	pass

func leave_state(pass_state):
	pass
	
func process_running():
	if(!ground_ray.is_colliding()):
		enter_state(state.falling)
	
	if(wall_ray.is_colliding()):
		scale.x *= -1
		
	global_position.x += move_speed * scale.x
	pass

func process_falling():
	current_fall_speed = lerp(current_fall_speed,max_fall_speed,0.04)
	global_position.x += move_speed_fall * scale.x
	global_position.y += current_fall_speed
	
	if(ground_ray.is_colliding()):
		global_position = ground_ray.get_collision_point()
		enter_state(state.running)
	pass

func _on_Timer_timeout():
	if(ground_ray.is_colliding()):
		enter_state(state.idle)
	pass # Replace with function body.

func _on_rat_animation_finished():
	if(animation == "idleclean" or animation == "idlestand"):
		enter_state(state.running)
	pass # Replace with function body.
