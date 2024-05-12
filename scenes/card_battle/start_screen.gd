class_name CardBattleStartScreen extends CanvasLayer


const player_vocations_dir = "res://resources/Characters/PlayerVocations/"
const cards_dir = "res://resources/CardAttributes/"
const enemies_dir = "res://scenes/enemies/"

var player_vocations = get_resources(player_vocations_dir, "tres", ["Vocation.tres"])
var cards = get_resources(cards_dir, "tres", ["CardAttributes.tres"])
var all_enemies = get_resources(enemies_dir, "tscn", ["Enemy.tscn"])

var card_battle = load("res://scenes/card_battle/card_battle.tscn")
var enemies = [] # Array[Array[PackedScene]]


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
	load_enemies()
	var new_card_battle = card_battle.instantiate()
	new_card_battle.player = load_player()
	new_card_battle.enemies = enemies.pop_front()
	new_card_battle.endless_mode = $EndlessMode.button_pressed
	new_card_battle.return_to_start_screen.connect(end_battle)
	new_card_battle.defeated_battle_enemies.connect(load_next_enemies)
	add_child(new_card_battle)


func load_player():
	var cards = get_selected_cards()
	var player_vocation = player_vocations_dir + $PlayerVocation.get_selected_metadata()
	var loaded_player_vocation = load(player_vocation)
	return Player.new(loaded_player_vocation, cards)


func get_selected_cards():
	var selected_cards = {}
	for child_node in $CardsContainer/Cards.get_children():
		if is_instance_of(child_node, SpinBox) and child_node.value > 0:
			var card_filename = child_node.get_meta("filename")
			selected_cards[card_filename] = child_node.value

	var cards: Array[CardAttributes] = []
	for filename in selected_cards:
		var card = load(cards_dir + filename)
		for x in range(selected_cards[filename]):
			cards.append(card)

	return cards


func load_enemies():

	if $EndlessMode.button_pressed:
		load_endless_enemies()
	else:
		var single_battle = []
		for enemy_option in [$Enemy1, $Enemy2, $Enemy3]:
			if enemy_option.get_selected_id() >= 0:
				single_battle.append(load(enemies_dir + enemy_option.get_selected_metadata()))
		enemies.append(single_battle)


func load_endless_enemies():
	var enemy_scenes = []
	for filename in all_enemies:
		enemy_scenes.append(load(enemies_dir + filename))

	for enemy_scene in enemy_scenes:
		enemies.append([enemy_scene])

	for first_enemy in enemy_scenes:
		for second_enemy in enemy_scenes:
			enemies.append([first_enemy, second_enemy])

	for first_enemy in enemy_scenes:
		for second_enemy in enemy_scenes:
			for third_enemy in enemy_scenes:
				enemies.append([first_enemy, second_enemy, third_enemy])


func end_battle():
	remove_child($CardBattle)
	show()


func load_next_enemies():
	await get_tree().create_timer(2).timeout
	$CardBattle.enemies = enemies.pop_front()
	$CardBattle.start_battle()
