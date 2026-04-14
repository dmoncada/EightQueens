import SwiftUI

struct BoardView: View {
  let solution: [Int]
  let width: CGFloat

  var imageUrl: URL? = nil
  var selectedRow: Int? = nil
  var onTapGesture: (Int?) -> Void = { _ in }

  var body: some View {
    let size = solution.count
    let cellSize = width / CGFloat(size)

    VStack(spacing: 0) {
      ForEach(0 ..< size, id: \.self) { row in
        HStack(spacing: 0) {
          ForEach(0 ..< size, id: \.self) { col in
            let hasPiece = solution[row] == col
            let selectedCol = selectedRow.map { solution[$0] }
            let isHighlighted = selectedRow != nil && (row == selectedRow || col == selectedCol)

            ZStack {
              Rectangle()
                .fill((row + col) % 2 == 0 ? Color.evenColor : .oddColor)
                .overlay(isHighlighted ? .green.opacity(0.25) : .clear)

              if hasPiece {
                QueenPiece(cellSize: cellSize, imageUrl: imageUrl)
              }
            }
            .frame(width: cellSize, height: cellSize)
            .onTapGesture {
              onTapGesture(hasPiece ? row : nil)
            }
          }
        }
      }
    }
  }
}

#Preview {
  BoardView(solution: [0, 1, 2, 3, 4, 5, 6, 7, 8], width: CGFloat(300))
}
