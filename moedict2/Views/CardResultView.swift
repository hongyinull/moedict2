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
            
            // 詞性定義卡片
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(Array(definitionsByType.keys.sorted()), id: \.self) { type in
                        if let definitions = definitionsByType[type] {
                            DefinitionCard(type: type, definitions: definitions)
                                .frame(maxWidth: .infinity) //卡片填滿寬度
//                                .scrollTransition { content, phase in
//                                    content
//                                        .opacity(phase.isIdentity ? 1 : 0.3)
//                                        .scaleEffect(phase.isIdentity ? 1 : 0.8)
//                                }//增加卡片滑入滑出視野的動畫效果
                        }
                        
                    }
                    CopyrightLabel().padding(.bottom, 4)
                }
            }
            .pinnedScrollView()
            .scrollTargetBehavior(.paging)
            .padding(.bottom)
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
    @State private var currentSelection: Int = 0 // 使用 @State 來追蹤當前選擇的卡片索引
    
    var body: some View {
            PageView(selection: $currentSelection) { // 傳遞 currentSelection
                ForEach(result.heteronyms.indices, id: \.self) { index in
                    CardResultView(
                        heteronym: result.heteronyms[index],
                        title: result.title,
                        radical: result.radical,
                        strokeCount: result.stroke_count
                    )
                    .background(.thinMaterial) // 設定背景為 thin 的 material
                    .aspectRatio(0.8, contentMode: .fit) // 調整卡片比例
                    .pageViewCardCornerRadius(30.0) // 設定卡片圓角
                    .pageViewCardShadow(.visible) // 設定卡片陰影
                    .onTapGesture {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred() // 觸發震動
                        print("Tapped card \(index)") // 點擊卡片時的動作
                    }
                    
                }
                
            }

        
        
        
            
            .pageViewStyle(.cardDeck) // 設定卡片樣式
            .scaleEffect(1.1) // 卡片倍數大小
            
            PageIndicator(
                selection: $currentSelection, // 使用 currentSelection 來表示選擇
                total: result.heteronyms.count // 總卡片數量
            )
            .pageIndicatorColor(.secondary.opacity(0.3)) // 設定指示器顏色
            .pageIndicatorCurrentColor(.accentColor) // 設定當前指示器顏色
            .allowsContinuousInteraction(true)
            .singlePageVisibility(.hidden)
            .pageIndicatorDuration(6.0)
            .offset(y: -20)
            .onChange(of: currentSelection) { _ in UIImpactFeedbackGenerator(style: .light).impactOccurred() } // 卡片翻頁時震動
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
