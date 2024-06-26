extends Node
class_name FSM
@export var initial_state: State

var current_state: State
var states: Dictionary = {}
@onready var label = $"../Label"

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transition.connect(on_state_transition)
	if initial_state:
		initial_state.Enter()
		current_state = initial_state

func _process(delta: float) -> void:
	if current_state:
		current_state.Update(delta)
	
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.Physics_Update(delta)

func on_state_transition(state, new_state_name) -> void:
	if state != current_state:
		return
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	if current_state:
		current_state.Exit()
	
	new_state.Enter()
	
	current_state = new_state
	label.text = current_state.name
