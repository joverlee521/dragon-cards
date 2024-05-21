# GdUnit generated TestSuite
class_name DeckTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

# TestSuite generated from
const __source = "res://scenes/card_battle/deck.gd"

# Shared variables within TestSuite
const DEFAULT_NUMBER_OF_CARDS = 5
var card_attributes: CardAttributes = ResourceLoader.load("res://resources/card_attributes/cards/big_hit.tres")
var cards: Array[CardAttributes] = []

# Executed before each test is started
func before_test() -> void:
	cards.assign(range(DEFAULT_NUMBER_OF_CARDS).map(
		func(_n: int) -> CardAttributes:
			return card_attributes
	))


func test_add_card() -> void:
	var runner: Object = scene_runner("res://scenes/card_battle/deck.tscn")
	runner.set_property("_cards", cards)
	var expected_number_of_cards: int = DEFAULT_NUMBER_OF_CARDS + 1
	runner.invoke("add_card", card_attributes)
	assert_int(runner.get_property("_cards").size()).is_equal(expected_number_of_cards)
	var card_count: Node = runner.find_child("CardCount")
	assert_str(card_count.text).is_equal(str(expected_number_of_cards))
	var deck_image: Node = runner.find_child("DeckImage")
	assert_bool(deck_image.visible).is_true()


func test_remove_all_cards() -> void:
	var runner: Object = scene_runner("res://scenes/card_battle/deck.tscn")
	runner.set_property("_cards", cards)
	var expected_number_of_cards: int = 0
	runner.invoke("remove_all_cards")
	assert_int(runner.get_property("_cards").size()).is_equal(expected_number_of_cards)
	var card_count: Node = runner.find_child("CardCount")
	assert_str(card_count.text).is_equal(str(expected_number_of_cards))
	var deck_image: Node = runner.find_child("DeckImage")
	assert_bool(deck_image.visible).is_false()


func test_remove_first_cards(
		num_cards_to_remove: int,
		test_parameters:= [
			[1],
			[2],
			[3],
			[4],
			[5],
			[6],
		]
	) -> void:
	var runner: Object = scene_runner("res://scenes/card_battle/deck.tscn")
	runner.set_property("_cards", cards)
	var expected_number_of_cards: int = DEFAULT_NUMBER_OF_CARDS - num_cards_to_remove
	if expected_number_of_cards < 0:
		expected_number_of_cards = 0
	runner.invoke("remove_first_cards", num_cards_to_remove)
	assert_int(runner.get_property("_cards").size()).is_equal(expected_number_of_cards)
	var card_count: Node = runner.find_child("CardCount")
	assert_str(card_count.text).is_equal(str(expected_number_of_cards))
	var deck_image: Node = runner.find_child("DeckImage")
	assert_bool(deck_image.visible).is_equal(expected_number_of_cards > 0)


func test_replace_cards() -> void:
	var runner: Object = scene_runner("res://scenes/card_battle/deck.tscn")
	runner.set_property("_cards", cards)
	const expected_number_of_cards = 10
	var new_cards: Array[CardAttributes] = []
	new_cards.assign(range(expected_number_of_cards).map(
		func(_n: int) -> CardAttributes:
			return card_attributes
	))
	runner.invoke("replace_cards", new_cards)
	assert_int(runner.get_property("_cards").size()).is_equal(expected_number_of_cards)
	var card_count: Node = runner.find_child("CardCount")
	assert_str(card_count.text).is_equal(str(expected_number_of_cards))
	var deck_image: Node = runner.find_child("DeckImage")
	assert_bool(deck_image.visible).is_equal(expected_number_of_cards > 0)
