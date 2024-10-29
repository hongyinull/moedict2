import SwiftUI

struct StrokeRadicalBadge: View {
    let radical: String
    let strokeCount: Int
    
    var body: some View {
        HStack(spacing: 8) {
            Text("\(radical)部")
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.tint.opacity(0.1))
                .cornerRadius(6)
            
            Text("\(strokeCount) 畫")
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.tint.opacity(0.1))
                .cornerRadius(6)
        }
        .font(.caption)
        .foregroundStyle(.tint)
    }
}

#Preview {
    StrokeRadicalBadge(radical: "女", strokeCount: 6)
        .padding()
}