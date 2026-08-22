extends Control

@export var leaderboard_internal_name: String = "clicker_game_lboard"

@onready var top_10_richtext: RichTextLabel = $RichTextLabel
@onready var player_score_label: Label = $YourScoreLabel


func _ready() -> void:
	top_10_richtext.text = "[center]Loading leaderboard...[/center]"
	player_score_label.text = "Loading your best score..."

	fetch_and_display_leaderboards()

func fetch_and_display_leaderboards() -> void:
	# 1. Fetch the top entries page
	var options := Talo.leaderboards.GetEntriesOptions.new()
	options.page = 0
	var page_data := await Talo.leaderboards.get_entries(leaderboard_internal_name, options)

	# 2. Fetch the current player's own entries (across all their aliases)
	var my_options := Talo.leaderboards.GetEntriesOptions.new()
	my_options.player_id = Talo.current_player.id
	var my_page_data := await Talo.leaderboards.get_entries(leaderboard_internal_name, my_options)

	# 3. Process the Top 10 Entries for the RichTextLabel
	var bbcode: String = "[center][b]TOP 10 PLAYERS[/b][/center]\n\n"

	if page_data and page_data.entries.size() > 0:
		var limit = min(page_data.entries.size(), 10)

		for i in range(limit):
			var entry: TaloLeaderboardEntry = page_data.entries[i]

			var rank = entry.position + 1
			var score = int(entry.score)
			# display_name falls back to the alias identifier (username) automatically
			var player_name = entry.player_alias.display_name

			bbcode += "[b]#%d[/b] %s - [color=green]%s[/color]\n" % [rank, player_name, str(score)]
	else:
		bbcode += "[center]No scores yet![/center]\n"

	top_10_richtext.text = bbcode

	# 4. Extract the player's best entry safely
	var my_entry: TaloLeaderboardEntry = null
	if my_page_data and my_page_data.entries.size() > 0:
		my_entry = my_page_data.entries[0]

	# 5. Display the player's best score safely
	if my_entry:
		player_score_label.text = "Your Best: #%d with a score of %s" % [my_entry.position + 1, str(int(my_entry.score))]
	else:
		player_score_label.text = "You haven't posted a score yet."



#var my_page_data = await Talo.leaderboards.get_entries_for_current_player(leaderboard_internal_name, options)
