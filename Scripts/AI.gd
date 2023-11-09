extends Node
#class_name AI


export var visualizer : NodePath
onready var visual = get_node(visualizer)


var board 


#func _ready():
#
#	var black_score = 0
#	var white_score = 0
#
#
#	var initial_state = State.new(BoardManager.current_board, black_score, white_score)
#
#
#	var result = alpha_beta_pruning(initial_state, BoardManager.WHITE, -INF, INF, BoardManager.DEPTH)
#	visual.update_board()
#
#
#
#
##	if (BoardManager.is_winner(initial_state.board, BoardManager.WHITE)):
##		print("WHITE WINS!")
#
#
#	var result2 = alpha_beta_pruning(initial_state, BoardManager.BLACK, INF, -INF, BoardManager.DEPTH)
#	initial_state = result2[1]


#	if (BoardManager.is_winner(initial_state.board, BoardManager.BLACK)):
#		print("BLACK WINS!")
	
	
		

		
		

	



#func alpha_beta_pruning(state, player, alpha, beta, depth):
#
#	if (BoardManager.is_winner(state.board, player)):
#		if (player == BoardManager.WHITE):
#			return INF
#			#return[INF, -1]
#		else:
#			return INF
#			#return[-INF, -1]
#	elif (depth==0):
#
#		var h = heuristic(state.board, player)
#		return h
#		#return[h, -1]
#
#
#	var move
#	var score 
#
#
#	if (player == BoardManager.WHITE):
#		score = -INF
#	else:
#		score = INF
#
#
#	var successors = Successor.calculate_successor(state, player)
#
#
#	#successor returns apllied action
#	#with board after that action and scores
#	for successor in successors:
#
#		var action = successor
#
#		var new_board = BoardManager.copy_board(state.board)
#
#
#		var new_player = BoardManager.BLACK
#		if (player == BoardManager.BLACK):
#			new_player = BoardManager.WHITE
#
#		var new_state = State.new(new_board, state.black_score, state.white_score)
#
#		var temp = alpha_beta_pruning(new_state, new_player, alpha, beta , depth-1)
#		# temp is score
#
#		if (player == BoardManager.WHITE):
#			if (temp > score):
#				score = temp
#				move = action
#
#		elif (player == BoardManager.BLACK):
#			if (temp < score):
#				score = temp
#				move = action
#
#		if (player == BoardManager.WHITE):
#			alpha = max(alpha, temp)
#		else:
#			beta = min(beta, temp)
#		if(alpha >= beta):
#			break
#
#	#move is successor	
#	board = move
#	return score	
#
#
#static func heuristic(board, player):
#	var player_white = BoardManager.WHITE
#	var player_black = BoardManager.BLACK
#
#
#	# number of remain pieces for a player
#	var white_pieces = BoardManager.number_of_pieces(board, player_white)
#	var black_pieces = BoardManager.number_of_pieces(board, player_black)
#	var remain_pieces = 0 
#
#
#
#	# distance from center for each piece in board
#	var distance = BoardManager.being_in_center(board)
#	var white_distance = distance[0]
#	var black_distance = distance[1]
#	var center = 0
#
#
#	if (player==player_white):
#		remain_pieces = white_pieces - black_pieces
#		center = white_distance - black_distance
#	else:
#		remain_pieces = player_black - player_white
#		center = black_distance - white_distance
#
#	#return (remain_pieces + center)
#	return (center)
#
