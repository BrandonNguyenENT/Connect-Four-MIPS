# Project Draft 1 - MIPS Assembly

.data
gameBoard: .space 64
Title:  .asciiz	"Current Project C Program Draft 1"
diceRoll:  .asciiz "Dice rolled: . It's Player 's turn."
piecePlacement:	.asciiz	"Player , enter a column number to display your piece: "
invalidColumn:	.asciiz	"Error, try a different column number"
fullColumn:	.asciiz	"Column is full. Please try a different column number."
winCondition:	.asciiz	"Player  is the winner."
drawCondition:	.asciiz	"Game is a Draw."


.text

# Functions to Implement

# createBoard
# printBoard
# displayPiece
# winCondition
# drawCondition
# diceRoll

# Other Unique Gameplay Mechanics to Add Later
# Pop a Piece Out
# Obstacle Blocker