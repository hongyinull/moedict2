import SwiftUI

struct DefinitionCard: View {
    let type: String
    let definitions: [Definition]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(type)
                .font(.headline)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.accentColor.opacity(0.1))
                .foregroundColor(.accentColor)
                .cornerRadius(8)
            
            ForEach(definitions.indices, id: \.self) { index in
                let def = definitions[index]
                VStack(alignment: .leading, spacing: 8) {
                    Text(def.def)
                        .font(.body)
                        .foregroundStyle(.primary)
                    
                    if let examples = def.example {
                        ForEach(examples, id: \.self) { example in
                            Text(example)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    if let quotes = def.quote {
                        ForEach(quotes, id: \.self) { quote in
                            Text(quote)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .italic()
                        }
                    }
                }
                .padding(.horizontal)
                
                if index < definitions.count - 1 {
                    Divider()
                }
            }
        }
        .padding()
        .background(.background)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

#Preview {
    DefinitionCard(
        type: "形",
        definitions: DictResponse.preview.heteronyms[0].definitions
    )
    .padding()
}