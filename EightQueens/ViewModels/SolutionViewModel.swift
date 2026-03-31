import Observation

@Observable
class SolutionViewModel {
  var gridSize = 8
  var isLoading = false
  var solutions: [[Int]] = []
  var currentIndex = 0

  func solve() async {
    isLoading = true

    let result = await Task.detached(priority: .userInitiated) {
      await placeQueens(self.gridSize)
    }.value

    await MainActor.run {
      self.solutions = result
      self.isLoading = false
    }
  }

  func showNext() {
    if solutions.isEmpty { return }
    currentIndex = (currentIndex + 1) % solutions.count
  }

  func showPrev() {
    if solutions.isEmpty { return }
    currentIndex = (currentIndex + solutions.count - 1) % solutions.count
  }
}
