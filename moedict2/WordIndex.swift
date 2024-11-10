// WordIndex.swift
// 處理詞彙索引的類別

import Foundation

class WordIndex: ObservableObject {
    // 儲存不同語言的詞彙陣列
    @Published private var wordsA: [String] = []  // 國語
    @Published private var wordsT: [String] = []    // 台語
    @Published private var wordsH: [String] = []    // 客語
    
    init() {
        loadAllIndices()
    }
    
    // 從本地讀取所有索引檔案
    private func loadAllIndices() {
        wordsA = loadIndex(name: "indexa")
        wordsT = loadIndex(name: "indext")
        wordsH = loadIndex(name: "indexh")
    }
    
    // 讀取單個索引檔案
    private func loadIndex(name: String) -> [String] {
        if let url = Bundle.main.url(forResource: name, withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let words = try? JSONDecoder().decode([String].self, from: data) {
            return words
        }
        print("索引檔案載入錯誤：\(name)")
        return []
    }
    
    // 根據字典類型取得搜尋建議
    func getSuggestions(for text: String, dictType: ContentView.DictType, limit: Int = 5) -> [String] {
        guard !text.isEmpty else { return [] }
        
        // 選擇對應的詞彙陣列
        let words = switch dictType {
        case .mandarin: wordsA
        case .taiwanese: wordsT
        case .hakka: wordsH
        }
        
        // 過濾包含搜尋文字的詞彙，並限制數量
        return words.filter { $0.contains(text) }.prefix(limit).map { $0 }
    }
} 
