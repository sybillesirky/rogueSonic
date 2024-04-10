extends Node

var currentCharacter = GlobalDefinitions.character.Sonic

var rng = RandomNumberGenerator.new()

var availableActionForward = GlobalDefinitions.specialAction.jumpDash
var availableActionUpward = GlobalDefinitions.specialAction.None
var availableActionDownward = GlobalDefinitions.specialAction.Bounce
