import Foundation
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

  private let session = URLSession(configuration: .default)
  private let rawUrl = URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/15/Chess_qlt45.svg/60px-Chess_qlt45.svg.png")!

  private var wrappedUrl: URL? = nil
  var imageUrl: URL? {
    get async throws {
      if wrappedUrl == nil {
        let (data, _) = try await session.data(from: rawUrl)
        wrappedUrl = URL(string: "data:image/png;base64," + data.base64EncodedString())
      }
      return wrappedUrl
    }
  }
}
