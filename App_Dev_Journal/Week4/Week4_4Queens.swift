//2. Development of logic to solve a 4 queen problem.
import Foundation

class FourQueens {
    private var board: [[Int]] = Array(repeating: Array(repeating: 0, count: 4), count: 4)

    func solve() {
        if placeQueen(row: 0) {
            printSolution()
        } else {
            print("No solution exists")
        }
    }

    private func placeQueen(row: Int) -> Bool {
        if row == 4 { return true }

        for col in 0..<4 {
            if isSafe(row: row, col: col) {
                board[row][col] = 1
                if placeQueen(row: row + 1) {
                    return true
                }
                board[row][col] = 0  // Backtrack
            }
        }
        return false
    }

    private func isSafe(row: Int, col: Int) -> Bool {
        // Check column
        for i in 0..<row {
            if board[i][col] == 1 {
                return false
            }
        }

        // Check upper left diagonal
        for (i, j) in zip(stride(from: row, to: -1, by: -1), stride(from: col, to: -1, by: -1)) {
            if board[i][j] == 1 {
                return false
            }
        }

        // Check upper right diagonal
        for (i, j) in zip(stride(from: row, to: -1, by: -1), stride(from: col, to: 4, by: 1)) {
            if board[i][j] == 1 {
                return false
            }
        }

        return true
    }

    private func printSolution() {
        for row in board {
            print(row.map { $0 == 1 ? "Q" : "." }.joined(separator: " "))
        }
    }
}

