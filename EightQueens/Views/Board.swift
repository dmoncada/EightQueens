import SwiftUI

struct BoardView: View {
  let solution: [Int]
  let size: CGFloat

  let evenColor: Color = Color(hex: "FFE1AF")!
  let unevenColor: Color = Color(hex: "957C62")!

  var body: some View {
    let cellSize = size / 8

    VStack(spacing: 0) {
      ForEach(0..<8) { row in
        HStack(spacing: 0) {
          ForEach(0..<8) { col in
            ZStack {
              Rectangle()
                .fill((row + col).isMultiple(of: 2) ? evenColor : unevenColor)

              if solution[row] == col {
                Image(systemName: "crown.fill")
                  .font(.system(size: cellSize * 0.5))
                  .foregroundColor(.black)
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
  BoardView(solution: [0, 1, 2, 3, 4, 5, 6, 7, 8], size: CGFloat(300))
}
