extends Node

enum character {
	Sonic,
	Shadow,
	Tails,
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
	Homing,
	HoverJump
}

enum chaoTypes {
	None,
	Cheese,
	Sonic,
	Shadow,
	Ifrit,
	Bounce,
	Tails
}

enum items {
	speedCapUp,
	jumpHeightUp,
	accelerationUp,
	brakePowerUp
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
	chaoTypes.Cheese,
	chaoTypes.Tails
]

# Item rarities
const commonItems = [
	items.jumpHeightUp,
	items.accelerationUp
]

const uncommonItems = [
	items.speedCapUp
]

const rareItems = [
	items.brakePowerUp
]
