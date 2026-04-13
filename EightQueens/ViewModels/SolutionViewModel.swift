import Observation

@MainActor
@Observable
class SolutionViewModel {
  var gridSize = 8
  var isLoading = false
  var solutions: [[Int]] = []
  var selectedRow: Int? = nil

  var currentIndex = 0 {
    didSet {
      selectedRow = nil
    }
  }

  func solve() async {
    defer {
      isLoading = false
    }

    isLoading = true
    currentIndex = 0

    let task = Task.detached(priority: .userInitiated) {
      await placeQueens(self.gridSize)
    }

    solutions = await task.value
  }

  func showNext() {
    if solutions.isEmpty { return }
    currentIndex = (currentIndex + 1) % solutions.count
  }

  func showPrev() {
    if solutions.isEmpty { return }
    currentIndex = (currentIndex + solutions.count - 1) % solutions.count
  }

  var solution: [Int] {
    if isLoading { return [] }
    return solutions[currentIndex]
  }
}
