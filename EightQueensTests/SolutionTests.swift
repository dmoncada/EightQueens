import Testing

@testable import EightQueens

struct SolutionTests {
  @Test func testSolutionsCount() async {
    let solutions = await placeQueens(8)
    #expect(solutions.count == 92)
  }

  @Test func testNoTwoQueensTouch() async {
    let solutions = await placeQueens(8)
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
