class_name CardBattleStartScreen extends CanvasLayer


const player_vocations_dir = "res://resources/PlayerVocations/"
const cards_dir = "res://resources/cards/"
const enemies_dir = "res://scenes/enemies/"

var player_vocations = get_resources(player_vocations_dir, "tres", ["vocation.tres"])
var cards = get_resources(cards_dir, "tres", ["card.tres"])
var all_enemies = get_resources(enemies_dir, "tscn", ["enemy.tscn"])

var card_battle = load("res://scenes/card_battle/card_battle.tscn")


func _ready():
	create_player_vocation_options()
	create_card_options()
	for enemy_option in [$Enemy1, $Enemy2, $Enemy3]:
		create_enemies_options(enemy_option)


func get_resources(path: String, file_extension: String, skip_resources: Array[String]) -> Array:
	var resources = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				continue

			if file_name.get_extension() == file_extension and file_name not in skip_resources:
				resources.append(file_name)

			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

	return resources


func create_player_vocation_options():
	for i in range(player_vocations.size()):
		var vocation = player_vocations[i]
		$PlayerVocation.add_item(vocation)
		$PlayerVocation.set_item_metadata(i, vocation)

	$PlayerVocation.selected = 0


func create_card_options():
	for i in range(cards.size()):
		var card = cards[i]
		var label = Label.new()
		label.text = card
		var number_input = SpinBox.new()
		number_input.min_value = 0
		number_input.set_meta("filename", card)
		$CardsContainer/Cards.add_child(label)
		$CardsContainer/Cards.add_child(number_input)


func create_enemies_options(option_node):
	for i in range(all_enemies.size()):
		var enemy = all_enemies[i]
		option_node.add_item(enemy)
		option_node.set_item_metadata(i, enemy)

	option_node.selected = -1


func start_battle():
	hide()
	var new_card_battle = card_battle.instantiate()
	new_card_battle.player = load_player()
	new_card_battle.enemies = load_enemies()
	new_card_battle.return_to_start_screen.connect(end_battle)
	add_child(new_card_battle)


func load_player():
	var cards = get_selected_cards()
	var player_vocation = player_vocations_dir + $PlayerVocation.get_selected_metadata()
	return Player.new(load(player_vocation), cards)


func get_selected_cards():
	var selected_cards = {}
	for child_node in $CardsContainer/Cards.get_children():
		if is_instance_of(child_node, SpinBox) and child_node.value > 0:
			var card_filename = child_node.get_meta("filename")
			selected_cards[card_filename] = child_node.value

	var cards = []
	for filename in selected_cards:
		var card = load(cards_dir + filename)
		for x in range(selected_cards[filename]):
			cards.append(card)

	return cards


func load_enemies():
	var enemies = []
	for enemy_option in [$Enemy1, $Enemy2, $Enemy3]:
		if enemy_option.get_selected_id() >= 0:
			enemies.append(load(enemies_dir + enemy_option.get_selected_metadata()))

	return enemies


func end_battle():
	remove_child($CardBattle)
	show()
