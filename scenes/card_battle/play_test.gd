class_name PlayTestCardBattle
extends CanvasLayer
## Developer start screen to play test the CardBattle

#region Signals ####################################################################################


#endregion
#region Enums ######################################################################################


#endregion
#region Constants ##################################################################################

const PLAYER_VOCATIONS_DIR := "res://resources/characters/vocations/player_vocations/"
const CARD_ATTRIBUTES_DIR := "res://resources/card_attributes/cards/"
const ENEMY_SCENES_DIR := "res://scenes/enemies/"
const CARD_BATTLE_SCENE := preload("res://scenes/card_battle/card_battle.tscn")

#endregion
#region @export variables ##########################################################################


#endregion
#region Public variables ###########################################################################

var player_vocations: Array[String] = get_resources(PLAYER_VOCATIONS_DIR, "tres", [])
var cards: Array[String] = get_resources(CARD_ATTRIBUTES_DIR, "tres", [])
var all_enemies: Array[String] = get_resources(ENEMY_SCENES_DIR, "tscn", ["enemy.tscn"])
var enemies: Array = [] # Array[Array[PackedScene]]
var enemy_options: Array = []

#endregion
#region Private variables ##########################################################################

var _card_battle: Node
var _endless_mode: bool = false

#endregion
#region @onready variables #########################################################################


#endregion
#region Optional _init method ######################################################################


#endregion
#region Optional _enter_tree() method ##############################################################


#endregion
#region Optional _ready method #####################################################################

func _ready() -> void:
	create_player_vocation_options()
	create_card_options()
	enemy_options = [
		$EnemyContainer/EnemySelection/Enemy1,
		$EnemyContainer/EnemySelection/Enemy2,
		$EnemyContainer/EnemySelection/Enemy3
	]
	for enemy_option: Node in enemy_options:
		create_enemies_options(enemy_option)

#endregion
#region Optional remaining built-in virtual methods ################################################


#endregion
#region Public methods #############################################################################

func start_battle() -> void:
	hide()
	_card_battle = CARD_BATTLE_SCENE.instantiate()
	_card_battle.exit_card_battle.connect(end_battle)
	load_player()
	load_enemies()
	load_card_battle_enemies()
	get_tree().get_root().add_child(_card_battle)


func load_player() -> void:
	var selected_cards: Array = get_selected_cards()
	var player_vocation_options: Node = $PlayerContainer/VocationContainer/PlayerVocationOptions
	var player_vocation: String = PLAYER_VOCATIONS_DIR + player_vocation_options.get_selected_metadata()
	var loaded_player_vocation: Vocation = ResourceLoader.load(player_vocation)
	_card_battle.player = Character.new(loaded_player_vocation, selected_cards)


func get_selected_cards() -> Array:
	var selected_cards := {}
	for child_node in $PlayerContainer/CardsContainer/CardsSelection.get_children():
		if is_instance_of(child_node, SpinBox) and child_node.value > 0:
			var card_filename: String = child_node.get_meta("filename")
			selected_cards[card_filename] = child_node.value

	var loaded_cards: Array[CardAttributes] = []
	for filename: String in selected_cards:
		var loaded_card: CardAttributes = load(CARD_ATTRIBUTES_DIR + filename)
		for x in range(selected_cards[filename]):
			loaded_cards.append(loaded_card)

	return loaded_cards


func load_enemies() -> void:

	if _endless_mode:
		load_endless_enemies()
	else:
		var single_battle := []
		for enemy_option: Node in enemy_options:
			if enemy_option.get_selected_id() >= 0:
				single_battle.append(load(ENEMY_SCENES_DIR + enemy_option.get_selected_metadata()))
		enemies.append(single_battle)


func load_endless_enemies() -> void:
	var enemy_scenes := []
	for filename in all_enemies:
		enemy_scenes.append(load(ENEMY_SCENES_DIR + filename))

	for enemy_scene: PackedScene in enemy_scenes:
		enemies.append([enemy_scene])

	for first_enemy: PackedScene in enemy_scenes:
		for second_enemy: PackedScene in enemy_scenes:
			enemies.append([first_enemy, second_enemy])

	for first_enemy: PackedScene in enemy_scenes:
		for second_enemy: PackedScene in enemy_scenes:
			for third_enemy: PackedScene in enemy_scenes:
				enemies.append([first_enemy, second_enemy, third_enemy])


func end_battle(_exit_status: CardBattle.EXIT_STATUS, _player: Character) -> void:
	get_tree().get_root().remove_child(_card_battle)

	if _endless_mode and _exit_status == CardBattle.EXIT_STATUS.WIN:
		load_card_battle_enemies()
		get_tree().get_root().add_child(_card_battle)
		_card_battle.start_battle()
	else:
		_card_battle.queue_free()
		show()


func load_card_battle_enemies() -> void:
	var current_enemies: Array = enemies.pop_front()
	_card_battle.enemies.assign(current_enemies)
	enemies.append(current_enemies)


func get_resources(
		path: String,
		file_extension: String,
		skip_resources: Array[String]) -> Array[String]:
	var resources: Array[String] = []
	var dir := DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name := dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				continue

			if file_name.get_extension() == file_extension and file_name not in skip_resources:
				resources.append(file_name)

			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

	return resources


func create_player_vocation_options() -> void:
	var player_vocation_options: Node = $PlayerContainer/VocationContainer/PlayerVocationOptions
	for i in range(player_vocations.size()):
		var vocation: String = player_vocations[i]
		player_vocation_options.add_item(vocation)
		player_vocation_options.set_item_metadata(i, vocation)

	player_vocation_options.selected = 0


func create_card_options() -> void:
	var cards_selection_options: Node = $PlayerContainer/CardsContainer/CardsSelection
	for i in range(cards.size()):
		var card: String = cards[i]
		var label: Node = Label.new()
		label.text = card
		var number_input := SpinBox.new()
		number_input.min_value = 0
		number_input.set_meta("filename", card)
		cards_selection_options.add_child(label)
		cards_selection_options.add_child(number_input)


func create_enemies_options(option_node: Node) -> void:
	for i in range(all_enemies.size()):
		var enemy: String = all_enemies[i]
		option_node.add_item(enemy)
		option_node.set_item_metadata(i, enemy)

	option_node.selected = -1

#endregion
#region Private methods ############################################################################

func _on_endless_mode_pressed() -> void:
	_endless_mode = $EnemyContainer/PlayTestControls/EndlessMode.button_pressed

#endregion
#region Subclasses #################################################################################


#endregion
