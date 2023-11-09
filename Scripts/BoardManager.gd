extends Node


#export var AI_path : NodePath
#onready var artificial_intelligence = get_node(AI_path)

var current_board = []

var neighbors = {}
var TOTAL_PIECES = 14
var GAME_OVER = 8
var DEPTH = 2

enum {EMPTY, BLACK, WHITE} # used to represent the board
# BLACK = 1 , WHITE = 2
enum {L, UL, UR, R, DR, DL} # used to represent the directions of neighbors

func _ready():
	init_board()
		

func init_board():
	var file = File.new()
	file.open("res://adjacency_lists.json", File.READ)
	var raw_data = file.get_as_text()
	var adjacency_lists = parse_json(raw_data)
	file.close() # reading the file that specifies the adjacency lists and converting it to a dictionary
	
	for cell_number in range(61):
		var cell_value = EMPTY
		if (cell_number >= 0 and cell_number <= 10) or (cell_number >= 13 and cell_number <= 15):
			cell_value = BLACK
		elif (cell_number >= 45 and cell_number <= 47) or (cell_number >= 50 and cell_number <= 60):
			cell_value = WHITE
		else:
			cell_value = EMPTY # determining the value of the current board cell
		
		current_board.append(cell_value)
		neighbors[cell_number] = []
		for neighbor in adjacency_lists[str(cell_number)]:
			neighbors[cell_number].append(int(neighbor))

		
func check_cluster(board, cell_number, piece, cluster_length, cluster_direction):
	if board[cell_number] != piece:
		return false
	
	var neighbor = cell_number
	for i in range(1, cluster_length):
		neighbor = neighbors[neighbor][cluster_direction]
		if neighbor == -1:
			return false
		elif board[neighbor] != piece:
			return false
	return true
	
func get_stats(board, cell_number, piece, cluster_length, cluster_direction):
	var num_side_pieces = 0
	var num_opponent_pieces = 0
	var piece_has_space = false
	var opponent_has_space = false
	var is_sandwich = false
	
	var current_point = cell_number
	for i in range(cluster_length + cluster_length):
		if board[current_point] == piece:
			if num_opponent_pieces > 0:
				is_sandwich = true
				break
			else:	
				num_side_pieces += 1
				if neighbors[current_point][cluster_direction] != -1:
					if board[neighbors[current_point][cluster_direction]] == EMPTY and i == cluster_length - 1:
						piece_has_space = true
						break
					
		elif board[current_point] == EMPTY:
			continue
			
		else: # opponent
			if num_side_pieces == cluster_length:
				num_opponent_pieces += 1
			if neighbors[current_point][cluster_direction] != -1:
				if board[neighbors[current_point][cluster_direction]] == EMPTY and piece_has_space == false and num_side_pieces == cluster_length and i != cluster_length + cluster_length - 1:
					opponent_has_space = true
					break
		
		current_point = neighbors[current_point][cluster_direction]
		if current_point == -1:
			break
	return {"number of side pieces" : num_side_pieces, "number of opponent pieces" : num_opponent_pieces, \
			"piece has space" : piece_has_space, "opponent has space" : opponent_has_space, 
			"is sandwich" : is_sandwich}
	
func test_board():
	for i in range(61):
		if neighbors[i][L] != -1: # check the correctness of left neighbors
			if neighbors[neighbors[i][L]][R] != i:
				print("Incorrect Left Neighbor: ", i, ", ", neighbors[neighbors[i][L]][R])
				
		if neighbors[i][UL] != -1: # check the correctness of up left neighbors
			if neighbors[neighbors[i][UL]][DR] != i:
				print("Incorrect Up Left Neighbor: ", i, ", ", neighbors[neighbors[i][UL]][DR])
		
		if neighbors[i][UR] != -1: # check the correctness of up right neighbors
			if neighbors[neighbors[i][UR]][DL] != i:
				print("Incorrect Up Right Neighbor: ", i, ", ", neighbors[neighbors[i][UR]][DL])
				
		if neighbors[i][R] != -1: # check the correctness of right neighbors
			if neighbors[neighbors[i][R]][L] != i:
				print("Incorrect Right Neighbor: ", i, ", ", neighbors[neighbors[i][R]][L])
				
		if neighbors[i][DR] != -1: # check the correctness of down right neighbors
			if neighbors[neighbors[i][DR]][UL] != i:
				print("Incorrect Down Right Neighbor: ", i, ", ", neighbors[neighbors[i][DR]][UL])
				
		if neighbors[i][DL] != -1:
			if neighbors[neighbors[i][DL]][UR] != i:
				print("Incorrect Down Left Neighbor: ", i, ", ", neighbors[neighbors[i][DL]][UR])

func number_of_pieces(board, piece):
	var count = 0
	for cell in range(61):
		if board[cell] == piece:
			count+=1

	return count

func stages(position):

	# up and down 
	if (position >= 0 and position <= 4) or (position >= 56 and position <= 60):
		return 20
	# corners (right and left)
	elif (position==26) or (position==34):
		return 20
	# left up
	elif (position==5) or (position==11) or (position==18):
		return 20
	# left down
	elif (position==35) or (position==43) or (position==50):
		return 20
	# right up
	elif (position==10) or (position==17) or (position==25):
		return 20
	# right down
	elif(position==42) or (position==49) or (position==55):
		return 20

	# up and down 
	elif (position >= 6 and position <= 9) or (position >= 51 and position <= 54):
		return 12
	# corners (right and left)
	elif (position==27) or (position==33):
		return 12
	# left up
	elif (position==12) or (position==19):
		return 12
	# left down
	elif (position==36) or (position==44):
		return 12
	# right up
	elif (position==16) or (position==24):
		return 12
	# right down
	elif(position==41) or (position==48):
		return 12

	# up and down 
	elif (position >= 13 and position <= 15) or (position >= 45 and position <= 47):
		return 8
	# corners (right and left)
	elif (position==28) or (position==32):
		return 8
	# left up
	elif (position==20):
		return 8
	# left down
	elif (position==37):
		return 8
	# right up
	elif (position==23):
		return 8
	# right down
	elif(position==40):
		return 8

	# up
	elif (position==21) or (position==22):
		return 3

	# down
	elif (position==38) or (position==39):
		return 3

	# corners (right and left)
	elif (position==29) or (position==31):
		return 3
	elif(position == 30):
		return 1	

func remaining_pieces(board, player):
		
	var player_ratio = 75
	var opponent_ratio = 60
	var total = 0
	
	var player_count = 0
	var opponent_count = 0
	
	var opponent = BoardManager.WHITE
	if (player == BoardManager.WHITE):
		opponent = BLACK
	
	
	player_count = number_of_pieces(board, player) 
	opponent_count = number_of_pieces(board, opponent) 
	
	if (player_count - opponent_count) > 0:
		total = (player_count - opponent_count) * opponent_ratio
	else:
		total = (player_count - opponent_count) * player_ratio
	
	return total			
	
func being_in_center(board, player):
	var player_ratio = 2
	var opponent_ratio = 10
	var total = 0
	var stage = 0
	
	var opponent = BLACK
	if(player == BLACK):
		opponent = WHITE
	
	for cell in range(61):
		if (board[cell] == player):
			stage = stages(cell)
			total -= (player_ratio + stage)
		elif(board[cell] == opponent):
			stage = stages(cell)
			total += (opponent_ratio + stage)
		
	return total


func is_winner(board, piece):
	var opponent = WHITE
	if (piece == WHITE):
		opponent = BLACK
		
	var pieces = number_of_pieces(board , opponent)
	if (pieces <= GAME_OVER):
		return true
	return false
	
func copy_board(board):
	var new_board = []
	for cell in range(61):
		new_board.append(board[cell])
		
	return new_board
		
func print_board(board):
	for cell in range(61):
		print(board[cell])
