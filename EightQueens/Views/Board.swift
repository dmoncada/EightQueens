import SwiftUI

struct BoardView: View {
  let solution: [Int]
  let width: CGFloat
  let size: Int

  let evenColor = Color(hex: "FFE1AF") ?? .black
  let oddColor = Color(hex: "957C62") ?? .white

  var body: some View {
    let cellSize = width / CGFloat(size)

    VStack(spacing: 0) {
      ForEach(0 ..< size, id: \.self) { row in
        HStack(spacing: 0) {
          ForEach(0 ..< size, id: \.self) { col in
            ZStack {
              Rectangle()
                .fill((row + col).isMultiple(of: 2) ? evenColor : oddColor)

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
  BoardView(solution: [0, 1, 2, 3, 4, 5, 6, 7, 8], width: CGFloat(300), size: 8)
}
