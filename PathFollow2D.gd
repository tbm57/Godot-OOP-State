extends PathFollow2D

enum STATES { FORWARD, BACKWARD, PAUSE, PLAY }

class State:
	const SPEED = 300

	var node: Node2D
	var previous_state: State
	
	func _init(_node: Node2D, _previous_state: State):
		node = _node
		previous_state = _previous_state
		
	func apply_movement(delta): pass
	
	func next(state: STATES) -> State:
		var result = self
		match state:
			STATES.BACKWARD: result = Backward.new(node, self)
			STATES.FORWARD: result = Forward.new(node, self)
			STATES.PAUSE: result = Paused.new(node, self)
		return result
		
class Forward extends State:
	func apply_movement(delta):
		node.progress += SPEED * delta

class Backward extends State:
	func apply_movement(delta):
		node.progress -= SPEED * delta
		
class Paused extends State:
	func apply_movement(delta):
		pass
		
	func next(state: STATES) -> State:
		if (state == STATES.PLAY):
			return previous_state
		else:
			return super(state)
	
var current_state = Forward.new(self, null)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_state.apply_movement(delta)
	
func change_state(next_state):
	current_state = current_state.next(next_state)
