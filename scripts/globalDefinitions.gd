extends Node

enum character {
	Sonic,
	Shadow,
	SuperSonic
}

enum state {
	Idle,
	Run,
	Jump,
	Fall,
	Roll,
	Hurt,
	Crouch
}

enum specialAction {
	None,
	jumpDash,
	chaosDash,
	Bounce,
	Homing
}

enum chaoTypes {
	None,
	Cheese,
	Sonic,
	Shadow,
	Ifrit,
	Bounce
}

# Chao default slots so they know where to go.
# Passive Chao are those that aren't in these categories.
const chaoDefaultForward = [
	chaoTypes.Sonic,
	chaoTypes.Shadow
]

const chaoDefaultDownward = [
	chaoTypes.Bounce
]

const chaoDefaultUpward = [
	chaoTypes.Cheese
]
