//1. Development of structures and classes for the tic tac toe game.
import Foundation

enum Player: String {
    case X = "X"
    case O = "O"
}

struct Board {
    private var grid: [[String]]

    init() {
        self.grid = Array(repeating: Array(repeating: " ", count: 3), count: 3)
    }

    mutating func makeMove(row: Int, col: Int, player: Player) -> Bool {
        if grid[row][col] == " " {
            grid[row][col] = player.rawValue
            return true
        }
        return false
    }

    func displayBoard() {
        for row in grid {
            print(row.map { $0 }.joined(separator: " | "))
            print("---------")
        }
    }

    func checkWinner() -> Player? {
        let winningLines = [
            // Rows
            [(0,0), (0,1), (0,2)],
            [(1,0), (1,1), (1,2)],
            [(2,0), (2,1), (2,2)],
            // Columns
            [(0,0), (1,0), (2,0)],
            [(0,1), (1,1), (2,1)],
            [(0,2), (1,2), (2,2)],
            // Diagonals
            [(0,0), (1,1), (2,2)],
            [(0,2), (1,1), (2,0)]
        ]

        for line in winningLines {
            let symbols = line.map { grid[$0.0][$0.1] }
            if symbols.allSatisfy({ $0 == "X" }) {
                return .X
            } else if symbols.allSatisfy({ $0 == "O" }) {
                return .O
            }
        }

        return nil
    }

    func isFull() -> Bool {
        return grid.allSatisfy { row in row.allSatisfy { $0 != " " } }
    }
}

class TicTacToe {
    private var board = Board()
    private var currentPlayer: Player = .X

    func playGame() {
        while true {
            board.displayBoard()
            print("\(currentPlayer.rawValue)'s turn! Enter row and column (0-2): ", terminator: "")
            if let input = readLine(), let row = Int(input.split(separator: " ")[0]), let col = Int(input.split(separator: " ")[1]) {
                if board.makeMove(row: row, col: col, player: currentPlayer) {
                    if let winner = board.checkWinner() {
                        board.displayBoard()
                        print("\(winner.rawValue) wins!")
                        break
                    } else if board.isFull() {
                        board.displayBoard()
                        print("It's a draw!")
                        break
                    }
                    currentPlayer = (currentPlayer == .X) ? .O : .X
                } else {
                    print("Invalid move, try again.")
                }
            }
        }
    }
}
