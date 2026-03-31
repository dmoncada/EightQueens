import Testing

@testable import EightQueens

struct SolutionTests {
  @Test(arguments: [
    (4, 2),
    (5, 10),
    (6, 4),
    (7, 40),
    (8, 92),
  ])
  func testSolutionsCount(gridSize: Int, expected: Int) {
    let solutions = placeQueens(gridSize)
    #expect(expected == solutions.count)
  }

  @Test func testNoTwoQueensTouch() {
    let solutions = placeQueens(8)
    #expect(solutions.allSatisfy(isValid))
  }

  func isValid(_ solution: [Int]) -> Bool {
    let n = solution.count

    for row1 in 0 ..< n {
      for row2 in (row1 + 1) ..< n {
        let col1 = solution[row1]
        let col2 = solution[row2]

        if col1 == col2 {
          return false
        }

        let colDistance = abs(col1 - col2)
        let rowDistance = row1 - row2
        if rowDistance == colDistance {
          return false
        }
      }
    }

    return true
  }
}
