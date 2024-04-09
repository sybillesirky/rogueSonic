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
