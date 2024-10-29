// WordIndex.swift
// 處理詞彙索引的類別

import Foundation

class WordIndex: ObservableObject {
    // 儲存所有詞彙的陣列
    @Published private var words: [String] = []
    
    init() {
        loadLocalIndex()
    }
    
    // 從本地讀取索引檔案
    private func loadLocalIndex() {
        // 取得 Assets 中的 index.json 檔案
        if let url = Bundle.main.url(forResource: "index", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                words = try JSONDecoder().decode([String].self, from: data)
            } catch {
                print("索引檔案載入錯誤：\(error)")
            }
        }
    }
    
    // 取得搜尋建議
    func getSuggestions(for text: String, limit: Int = 5) -> [String] {
        guard !text.isEmpty else { return [] }
        // 過濾包含搜尋文字的詞彙，並限制數量
        return words.filter { $0.contains(text) }.prefix(limit).map { $0 }
    }
} 