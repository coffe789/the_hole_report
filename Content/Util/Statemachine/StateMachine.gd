extends Node
class_name StateMachine

var current_state : Node

func init_machine(target, init_state):
	$Transitions.target = target
	
	for state in $States.get_children():
		assert(state is State)
		state.target = target
		state.SM = self
		state.transitions = $Transitions
	
	current_state = init_state
	current_state.enter()

func update(delta):
	current_state.update(delta)
	
	var new_state = current_state.try_transition()
	if new_state != null && new_state != current_state:
		transition_state(new_state)

func transition_state(new_state):
	#print(current_state.name + " -> " + new_state.name)
	current_state.exit()
	new_state.enter()
	
	current_state = new_state
