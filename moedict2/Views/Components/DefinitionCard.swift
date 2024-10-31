import SwiftUI
import PinnedScrollView

/// 詞性定義卡片元件
struct DefinitionCard: View {
    let type: String
    let definitions: [Definition]
    
    // MARK: - 主視圖
    var body: some View {
        // 只有當詞性不為空時才顯示卡片
            VStack(alignment: .leading, spacing: 9) {
                // MARK: - 詞性標籤
                if !type.isEmpty {
                    Text(type)
                        .font(.headline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.tint.opacity(0.1))
                        .foregroundStyle(.tint)
                        .cornerRadius(8)
                }
                // MARK: - 釋義列表
                ForEach(Array(definitions.enumerated()), id: \.offset) { index, definition in
                    let def = definition
                    VStack(alignment: .leading, spacing: 8) {
                        // 釋義文字
                        Text(def.def)
                            .font(.body)
                            .foregroundStyle(.primary)
//                            .pinned()
                        
                        // MARK: - 例句區域
                        if let examples = def.example {
                            ForEach(examples, id: \.self) { example in
                                Text(example)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        // MARK: - 引用區域
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
//                    .frame(maxWidth: .infinity)
                    
                    // 分隔線：最後一個使用透明填充方塊
                    if index < definitions.count - 1 {
                        Divider()
                            .foregroundStyle(.separator)
                            .pinned()
                    } else {
                        Rectangle()
                            .fill(.clear)
                            .frame(height: 1)
                            .pinned()
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.thinMaterial)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

//#Preview {
//    DefinitionCard(
//        type: "形",
//        definitions: DictResponse.preview.heteronyms[0].definitions
//    )
//    .padding()
//}
