# GdUnit generated TestSuite
class_name CharacterTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

# TestSuite generated from
const __source = "res://resources/characters/character.gd"

# Shared variables withint TestSuite
var card: CardAttributes
var vocation: Vocation
var character: Character
var emitter: Object


func before_test() -> void:
	card = CardAttributes.new()
	vocation = Vocation.new(25, 5, [], [], [card])
	character = Character.new(vocation, [])
	emitter = monitor_signals(character)


func test_init_stats() -> void:
	const expected_health: int = 50
	const expected_defense: int = 40
	const expected_cards_size: int = 5
	var expected_cards: Array[CardAttributes] = []
	expected_cards.assign(range(expected_cards_size).map(func(_n: int) -> CardAttributes: return card))
	vocation = Vocation.new(expected_health, expected_defense, [], [], expected_cards)
	character = Character.new(vocation, [])
	emitter = monitor_signals(character)
	character.init_stats()
	await assert_signal(emitter).is_emitted("health_changed", [expected_health])
	await assert_signal(emitter).is_emitted("defense_changed", [expected_defense])
	assert_int(character._health).is_equal(expected_health)
	assert_int(character._defense).is_equal(expected_defense)
	assert_array(character.cards).has_size(expected_cards.size())


func test_init_stats_with_custom_character_cards() -> void:
	const expected_cards_size: int = 10
	var expected_cards: Array[CardAttributes] = []
	expected_cards.assign(range(10).map(func(n): return card))
	character.cards = expected_cards
	character.init_stats()
	assert_array(character.cards).has_size(expected_cards_size)


func test_remove_all_defense() -> void:
	const expected_defense: int = 0
	character.remove_all_defense()
	await assert_signal(emitter).is_emitted("defense_changed", [expected_defense])
	assert_int(character._defense).is_equal(expected_defense)


func test_add_defense() -> void:
	const expected_defense: int = 10
	character.add_defense(5)
	await assert_signal(emitter).is_emitted("defense_changed", [expected_defense])
	assert_int(character._defense).is_equal(expected_defense)


func test_add_health() -> void:
	const expected_health: int = 30
	character.add_health(5)
	await assert_signal(emitter).is_emitted("health_changed", [expected_health])
	assert_int(character._health).is_equal(expected_health)


func test_take_damage_not_ignoring_defense() -> void:
	const expected_defense: int = 0
	const expected_health: int = 20
	character.take_damage(10)
	await assert_signal(emitter).is_emitted("defense_changed", [expected_defense])
	await assert_signal(emitter).is_emitted("health_changed", [expected_health])
	assert_int(character._defense).is_equal(expected_defense)
	assert_int(character._health).is_equal(expected_health)


func test_take_damage_ignoring_defense() -> void:
	var expected_defense: int = vocation.starting_defense
	const expected_health: int = 15
	character.take_damage(10, true)
	await assert_signal(emitter).wait_until(50).is_not_emitted("defense_changed")
	await assert_signal(emitter).is_emitted("health_changed", [expected_health])
	assert_int(character._defense).is_equal(expected_defense)
	assert_int(character._health).is_equal(expected_health)
