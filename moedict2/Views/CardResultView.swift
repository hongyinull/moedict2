// NormalResultView.swift
// 處理字典搜尋結果的顯示視圖

import SwiftUI
import PinnedScrollView
import BigUIPaging


struct CardResultView: View {
    let heteronym: Heteronym
    let title: String
    let radical: String?
    let strokeCount: Int?
    let translations: [String: [String]]?
    
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
                .padding(.bottom, 0)
            
            // 詞性定義卡片和翻譯卡片
            ScrollView {
                Spacer().frame(height: 15)
                LazyVStack(spacing: 8) {
                    // 先顯示詞性定義卡片
                    ForEach(Array(definitionsByType.keys.sorted()), id: \.self) { type in
                        if let definitions = definitionsByType[type] {
                            DefinitionCard(type: type, definitions: definitions)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    
                    // 再顯示翻譯卡片
                    if let translations = translations, !translations.isEmpty {
                        ForEach(Array(translations.keys.sorted()), id: \.self) { language in
                            if let translationArray = translations[language] {
                                DefinitionCard(
                                    type: language,
                                    definitions: translationArray.map { 
                                        Definition(
                                            def: $0,
                                            type: nil,
                                            example: nil,
                                            quote: nil
                                        )
                                    }
                                )
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    
                    CopyrightLabel().padding(.bottom, 4)
                    Spacer().frame(height: 15)
                }
            }
            .scrollIndicators(.hidden)
            .padding(.bottom, -30)
            .padding(.top, -15)
            .scrollContentBackground(.visible)
        }
        .padding(30)
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
    @State private var currentSelection: Int = 0
    
    var body: some View {
        VStack {
            PageView(selection: $currentSelection) {
                ForEach(result.heteronyms.indices, id: \.self) { index in
                    CardResultView(
                        heteronym: result.heteronyms[index],
                        title: result.title,
                        radical: result.radical,
                        strokeCount: result.strokeCount,
                        translations: result.translations
                    )
                    .background(.thinMaterial)
                    .aspectRatio(0.6, contentMode: .fit)
                    .pageViewCardCornerRadius(30.0)
                    .pageViewCardShadow(.visible)
                    .onTapGesture {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        print("Tapped card \(index)")
                    }
                }
            }
            .pageViewStyle(.cardDeck)
            .scaleEffect(1.1)
            
            PageIndicator(
                selection: $currentSelection,
                total: result.heteronyms.count
            )
        }
    }
}

#Preview {
    // 為了更好的預覽效果，我們需要擴充預覽資料
    let previewResponse = try! JSONDecoder().decode(DictResponse.self, from: """
    {
        "t": "好",
        "h": [
            {
                "d": [
                    {
                        "definition": "美、善，理想的。",
                        "type": "形",
                        "example": ["如：「好東西」、「好風景」"],
                        "quote": ["唐．韋莊．菩薩蠻：「人人盡說江南好」"]
                    }
                ],
                "bopomofo": "ㄏㄠˇ",
                "pinyin": "hǎo"
            },
            {
                "d": [
                    {
                        "definition": "愛、喜愛。",
                        "type": "動",
                        "example": ["如：「好學不倦」"],
                        "quote": null
                    }
                ],
                "bopomofo": "ㄏㄠˋ",
                "pinyin": "hào"
            }
        ],
        "r": "女",
        "c": 6,
        "translation": {
            "English": ["good", "well", "proper", "nice"],
            "Deutsch": ["gut", "schön", "richtig"],
            "francais": ["bon", "bien"]
        }
    }
    """.data(using: .utf8)!)
    
    BigCardResultView(result: previewResponse)
}
