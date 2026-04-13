import SwiftUI

struct BoardView: View {
  let solution: [Int]
  let width: CGFloat

  var body: some View {
    let size = solution.count
    let cellSize = width / CGFloat(size)

    VStack(spacing: 0) {
      ForEach(0 ..< size, id: \.self) { row in
        HStack(spacing: 0) {
          ForEach(0 ..< size, id: \.self) { col in
            ZStack {
              Rectangle()
                .fill((row + col) % 2 == 0 ? Color.evenColor : .oddColor)

              if solution[row] == col {
                Image(systemName: "crown.fill")
                  .font(.system(size: cellSize * 0.5))
                  .foregroundStyle(.black)
              }
            }
            .frame(width: cellSize, height: cellSize)
          }
        }
      }
    }
  }
}

#Preview {
  BoardView(solution: [0, 1, 2, 3, 4, 5, 6, 7, 8], width: CGFloat(300))
}
