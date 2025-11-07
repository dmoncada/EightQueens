import Foundation

func placeQueens(_ gridSize: Int = 8) -> [[Int]] {
  func placeQueensRecursive(row: Int, columns: inout [Int]) -> [[Int]] {
    if row == gridSize {
      return [columns]
    }

    var solutions = [[Int]]()

    for col in 0..<gridSize {
      if checkValid(columns: &columns, row1: row, col1: col) {
        columns[row] = col

        let newSolutions = placeQueensRecursive(row: row + 1, columns: &columns)

        solutions.append(contentsOf: newSolutions)
      }
    }

    return solutions
  }

  func checkValid(columns: inout [Int], row1: Int, col1: Int) -> Bool {
    for row2 in 0..<row1 {
      let col2 = columns[row2]
      if col1 == col2 {
        return false
      }

      let colDistance = abs(col1 - col2)
      let rowDistance = row1 - row2
      if rowDistance == colDistance {
        return false
      }
    }

    return true
  }

  var columns = [Int](repeating: 0, count: gridSize)

  // Kick off the recursion.
  return placeQueensRecursive(row: 0, columns: &columns)
}
