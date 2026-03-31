func placeQueens(_ n: Int = 8) -> [[Int]] {
  var results = [[Int]]()
  var current = Array(repeating: -1, count: n)

  var cols = Set<Int>()
  var diag1 = Set<Int>()
  var diag2 = Set<Int>()

  func backtrack(_ row: Int) {
    if row == n {
      results.append(current)
      return
    }

    for col in 0 ..< n {
      if cols.contains(col) || diag1.contains(row - col) || diag2.contains(row + col) {
        continue
      }

      current[row] = col
      cols.insert(col)
      diag1.insert(row - col)
      diag2.insert(row + col)

      backtrack(row + 1)

      current[row] = -1
      cols.remove(col)
      diag1.remove(row - col)
      diag2.remove(row + col)
    }
  }

  backtrack(0)

  return results
}
