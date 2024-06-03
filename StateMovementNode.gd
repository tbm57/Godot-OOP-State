extends PathFollow2D

enum EVENTS { FORWARD, BACKWARD, PAUSE, PLAY }
enum STATES { FORWARD, BACKWARD, PAUSED }

class State extends RefCounted:
	const SPEED = 300

	var node: Node2D
	var previous_state: STATES
	var current_state: STATES
	
	func _init(_node: Node2D):
		node = _node
		
	func apply_movement(delta): pass
	
	func next(event: EVENTS) -> State:
		var result
		match event:
			EVENTS.FORWARD: result = Forward.new(node)
			EVENTS.BACKWARD: result = Backward.new(node)
			EVENTS.PAUSE: result = Paused.new(node, current_state)
			_: result = Forward.new(node)
		return result
		
class Forward extends State:
	func _init(_node: Node2D):
		super(_node)
		current_state = STATES.FORWARD
	
	func apply_movement(delta):
		node.progress += SPEED * delta

class Backward extends State:
	func _init(_node: Node2D):
		super(_node)
		current_state = STATES.BACKWARD
	
	func apply_movement(delta):
		node.progress -= SPEED * delta
		
class Paused extends State:
	func _init(_node: Node2D, _previous_state: STATES):
		super(_node)
		previous_state = _previous_state
		current_state = STATES.PAUSED
		
	func next(event: EVENTS) -> State:
		if (event == EVENTS.PLAY):
			if (previous_state == STATES.FORWARD):
				return Forward.new(node)
			elif (previous_state == STATES.BACKWARD):
				return Backward.new(node)
			else:
				return Paused.new(node, current_state)
		else:
			return super(event)
	
var current_state = Forward.new(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_state.apply_movement(delta)
	
func change_state(event: EVENTS):
	current_state = current_state.next(event)
