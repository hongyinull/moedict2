// NormalResultView.swift
// 處理字典搜尋結果的顯示視圖

import SwiftUI


struct CardResultView: View {
    let heteronym: Heteronym
    let title: String
    let radical: String?
    let strokeCount: Int?
    
    // 將定義按詞性分組
    private var definitionsByType: [String: [Definition]] {
        Dictionary(grouping: heteronym.definitions) { $0.type ?? "" }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 標題和部首筆畫區
            HStack(alignment: .top) {
                Text(title)
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(.primary)
                
                Spacer()
                
                if let radical = radical, let strokeCount = strokeCount {
                    StrokeRadicalBadge(radical: radical, strokeCount: strokeCount)
                }
            }
            
            // 注音和拼音
            HStack {
                if let bopomofo = heteronym.bopomofo {
                    Text(bopomofo)
                        .font(.system(size: 24))
                        .foregroundStyle(.primary)
                }
                if let pinyin = heteronym.pinyin {
                    Text(pinyin)
                        .font(.system(size: 20))
                        .foregroundStyle(.secondary)
                }
            }
            
            Divider()
                .foregroundStyle(.separator)
            
            // 詞性定義卡片
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(Array(definitionsByType.keys.sorted()), id: \.self) { type in
                        if let definitions = definitionsByType[type] {
                            DefinitionCard(type: type, definitions: definitions)
                                .frame(maxWidth: .infinity) // 讓卡片填滿寬度
                        }
                    }
                }
            }
            .scrollTargetBehavior(.paging)
            .padding()
        }
        .padding()
        .frame(height: UIScreen.main.bounds.height * 0.7) // 限制卡片高度
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
} 

// #Preview {
//     CardResultView(
//         heteronym: DictResponse.preview.heteronyms[0],
//         title: DictResponse.preview.title,
//         radical: DictResponse.preview.radical,
//         strokeCount: DictResponse.preview.stroke_count
//     )
// }

struct BigCardResultView: View {
    let result: DictResponse
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 20) {
                ForEach(result.heteronyms.indices, id: \.self) { index in
                    CardResultView(
                        heteronym: result.heteronyms[index],
                        title: result.title,
                        radical: result.radical,
                        strokeCount: result.stroke_count
                    )
                    .frame(width: UIScreen.main.bounds.width - 40)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                }
            }
            .scrollTargetLayout()
            .padding(.horizontal, 20)
        }
        .scrollTargetBehavior(.paging)
        .background(.ultraThinMaterial)
    }
}

#Preview {
    // 為了更好的預覽效果，我們需要擴充預覽資料
    let previewResponse = DictResponse(
        title: "好",
        heteronyms: [
            DictResponse.preview.heteronyms[0],
            Heteronym(
                definitions: [
                    Definition(
                        def: "愛、喜愛。",
                        type: "動",
                        example: ["如：「好學不倦」"],
                        quote: nil
                    )
                ],
                bopomofo: "ㄏㄠˋ",
                bopomofo2: "hàu",
                pinyin: "hào"
            )
        ],
        radical: "女",
        stroke_count: 6
    )
    
    return BigCardResultView(result: previewResponse)
}
