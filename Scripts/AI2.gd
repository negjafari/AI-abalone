extends Node



export var visualizer : NodePath
onready var visual = get_node(visualizer)

var transposition_table = []
var move_history = []

var iteration = 0

var show_history = false

var index = 0


var turn = true #white


var black_count = 0
var white_count = 0

var K_BEST = 10

var move 



func _process(_delta):
	
	if show_history:
		
		if Input.is_action_just_pressed("ui_left"):	
			if (index == 0):
				visual.update_board(move_history[index])
				index += 1
			elif (index < len(move_history) - 1):	
				visual.update_board(move_history[index])
				index += 1
							


		if Input.is_action_just_pressed("ui_right"):
			if (index > 1):
				visual.update_board(move_history[index])
				index -= 1
				
			
	
	else:
		if turn:
			if (iteration == 0):
				move_history.append(started_board())
			var alphabeta = alphabeta(BoardManager.current_board, BoardManager.WHITE, true, -INF, INF, BoardManager.DEPTH)	
			visual.update_board(move.board)
			BoardManager.current_board = move.board
			transposition_table.append(move.board)
			move_history.append(move.board)
			turn = false
			iteration += 1


		else:
			var alphabeta = alphabeta(BoardManager.current_board, BoardManager.BLACK, true, -INF, INF, BoardManager.DEPTH)	
			visual.update_board(move.board)
			BoardManager.current_board = move.board
			transposition_table.append(move.board)
			move_history.append(move.board)
			turn = true
			iteration += 1

	

		

func history():
	if Input.is_action_just_pressed("history"):
		return true


func alphabeta(board, player, condition, alpha, beta, depth):
	
	if BoardManager.is_winner(board, player):
		show_history = true
		if(condition):
			return INF
		else:
			return -INF
	
	if depth == 0:
		return heuristic(board,player)
		
		
	var score 
	if(condition):
		score = -INF
	else:
		score = INF
		
	var new_state = State.new(board,0,0)
	var successors = Successor.calculate_successor(new_state, player)
	
	
	if (player == BoardManager.BLACK):
		player = BoardManager.WHITE
	else:
		player = BoardManager.BLACK
		
		
	var states = []
	for successor in successors:
		var h = heuristic(successor.board, player)
		var state_info = StateInfo.new(successor, h)
		states.append(state_info)

	states = sort(states)
	
	for best_state in range(0, K_BEST):
		if (not is_duplicate(states[best_state].state.board, transposition_table)):
			
			var current_value = alphabeta(states[best_state].state.board, player, not condition , alpha, beta, depth - 1)
			
			if(condition):
				if current_value > score:
					score = current_value
					if depth == 2:
						move = states[best_state].state
					if alpha < score:
						alpha = score
			else:
				if current_value < score:
					score = current_value
					if depth == 2:
						move = states[best_state].state
					if beta > score:
						beta = score
				

		if beta <= alpha:
				break
	return score


	
func heuristic(board, player):
	
	var total = 0
	
	var opponent = BoardManager.BLACK
	if (player == BoardManager.BLACK):
		opponent = BoardManager.WHITE
		
		
	var center_weight = 1
	var pieces_wieght = 1

	var center = center_weight * BoardManager.being_in_center(board , player)
	var pieces = pieces_wieght * BoardManager.remaining_pieces(board, player)


	return pieces + center
	
	
func sort(array):
	for i in range (0, len(array) - 1):
		for j in range(0, len(array) - i - 1):
			if array[j].utility > array[j+1].utility:
				var temp = array[j]
				array[j] = array[j+1]
				array[j+1] = temp
	return array
	
	
func is_duplicate(current_board, table):
	for s in range (len(table)):
		if table[s] == current_board:
			return true
	return false


func started_board():
	var current_board = []
	for cell_number in range(61):
		var cell_value = BoardManager.EMPTY
		if (cell_number >= 0 and cell_number <= 10) or (cell_number >= 13 and cell_number <= 15):
			cell_value = BoardManager.BLACK
		elif (cell_number >= 45 and cell_number <= 47) or (cell_number >= 50 and cell_number <= 60):
			cell_value = BoardManager.WHITE
		else:
			cell_value = BoardManager.EMPTY # determining the value of the current board cell
		current_board.append(cell_value)
	return current_board
