import SwiftUI

struct CopyrightLabel: View {
    var body: some View {
        Link(destination: URL(string: "instagram://user?username=boiling_boyo")!) {
            HStack(spacing: 4) {
                Text("©")
                Text("2024")
                Text("BOILING_BOYO")
                    .underline()
            }
            .font(.caption2)
            .foregroundStyle(.secondary)
        }
    }
} 
