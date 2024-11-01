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
            
        }
        .padding(30)
//        .padding([.top, .horizontal])
//        .frame(height: UIScreen.main.bounds.height * 0.7) // 限制卡片高度
//        .background(.regularMaterial)
//        .clipShape(RoundedRectangle(cornerRadius: 16))
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
            // 確保有資料才顯示 PageView
            if !result.heteronyms.isEmpty {
                PageView(selection: $currentSelection) {
                    ForEach(0..<result.heteronyms.count, id: \.self) { index in
                        CardResultView(
                            heteronym: result.heteronyms[index],
                            title: result.title,
                            radical: result.radical,
                            strokeCount: result.stroke_count
                        )
                        .background(.thinMaterial)
                        .aspectRatio(0.6, contentMode: .fit)
                        .pageViewCardCornerRadius(30.0)
                        .pageViewCardShadow(.visible)
                        .onTapGesture {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        }
                    }
                }
                .pageViewStyle(.cardDeck)
                .scaleEffect(1.1)
                
                // 只在有多個讀音時顯示指示器
                if result.heteronyms.count > 1 {
                    PageIndicator(
                        selection: $currentSelection,
                        total: result.heteronyms.count
                    )
                    .pageIndicatorColor(.secondary.opacity(0.3))
                    .pageIndicatorCurrentColor(.accentColor)
                    .singlePageVisibility(.hidden)
                    .pageIndicatorDuration(6.0)
                    .offset(y: -20)
                    .onChange(of: currentSelection) { _ in
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                }
            } else {
                // 當沒有資料時顯示提示
                ContentUnavailableView(
                    "無法顯示結果",
                    systemImage: "exclamationmark.triangle",
                    description: Text("找不到相關資料")
                )
            }
        }
        // 確保 currentSelection 不會超出範圍
        .onChange(of: result.heteronyms.count) { newCount in
            if currentSelection >= newCount {
                currentSelection = max(0, newCount - 1)
            }
        }
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
                        def: "愛、喜愛。愛、喜愛。愛、喜愛。愛、喜愛。愛、喜愛。愛、喜愛。愛、喜愛。愛、喜愛。愛、喜愛。愛、喜愛。愛、喜愛。愛、喜愛。愛、喜愛。愛、喜愛。愛、喜愛。愛、喜愛。愛、喜愛。愛、喜愛。愛、喜愛。愛、喜愛。愛、喜愛。愛、喜愛。愛、喜愛。愛、喜愛。愛、喜愛。愛、喜愛。愛、喜愛。",
                        type: "動",
                        example: ["如：「好學不倦」如：「好學不倦」如：「好學不倦」如：「好學不倦」如：「好學不倦」如：「好學不倦」如：「好學不倦」如：「好學不倦」如：「好學不倦」如：「好學不倦」如：「好學不倦」如：「好學不倦」如：「好學不倦」如：「好學不倦」如：「好學不倦」如：「好學不倦」如：「好學不倦」"],
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
