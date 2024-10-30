import SwiftUI

struct CopyrightLabel: View {
    var body: some View {
        Link(destination: URL(string: "instagram://user?username=hongyinull")!) {
            HStack(spacing: 4) {
                Text("©")
                Text("2024")
                Text("HONGYINULL")
                    .underline()
            }
            .font(.caption2)
            .foregroundStyle(.secondary)
        }
    }
} 