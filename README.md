# Abalone Game with Godot

This Abalone game implementation in Godot includes various advanced features to enhance gameplay and strategy.Two AI opponent play against eachother using the Minimax algorithm with alpha-beta pruning and an evaluation function. The game also supports saving move history and managing repeated moves with a transposition table.

## Features

1. **Minimax Algorithm with Alpha-Beta Pruning**
   - The game includes an AI opponent that can play against another AI.
   - The AI uses the Minimax algorithm with alpha-beta pruning for efficient decision making.

2. **Customizable Depth and Evaluation Function**
   - You can customize the depth of the Minimax algorithm to control the AI's level of difficulty.
   - The evaluation function considers:
     - Being in the center of the board for strategic positioning.
     - The number of remaining pieces to assess the game state.

3. **Forward Pruning with Beam Search**
   - Forward pruning improves the AI's efficiency by reducing the search space.
   - Beam search is employed to explore promising paths while ignoring less favorable ones.

4. **Move History**
   - The game records and saves the history of moves made during a game.
   - Players can review and analyze the moves to improve their strategies.

5. **Transposition Table**
   - To optimize game performance, a transposition table is used to manage repeated moves.
   - This reduces redundant calculations and speeds up gameplay.

6. **Interactive Move Viewing**
   - You can navigate through the move history using left and right arrows.
   - This feature allows for in-depth analysis and understanding of game progression.

## Getting Started

To run the game, you will need Godot Engine version 3.4.4 or compatible. Follow these steps:
1. Clone the repository to your local machine:
2. Open Godot Engine and import the project by selecting the project.godot file.
3. You can review and analyze your moves and those of your opponent using the Move History feature with left and right arrows.
