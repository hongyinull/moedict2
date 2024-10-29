//
//  ContentView.swift
// 實現簡單的萌典查詢介面

import SwiftUI

struct ContentView: View {
    // 搜尋關鍵字的狀態變數，預設值設為「萌」
    @State private var searchText = "萌"
    // 儲存查詢結果的狀態變數
    @State private var searchResult: DictResponse?
    // 顯示錯誤訊息的狀態變數
    @State private var showError = false
    // 新增的狀態變數
    @State private var suggestions: [String] = []
    // 新增詞彙索引管理器
    @StateObject private var wordIndex = WordIndex()
    
    var body: some View {
        VStack {
            // 搜尋區域
            HStack {
                TextField("搜尋", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    // 設定鍵盤回車鍵為搜尋
                    .submitLabel(.search)
                    // 當按下搜尋鍵時執行搜尋
                    .onSubmit(performSearch)
                    // 監聽輸入變化
                    .onChange(of: searchText) { newValue in
                        suggestions = wordIndex.getSuggestions(for: newValue)
                    }
                
                Button(action: performSearch) {
                    Text("查詢")
                }
                .padding(.trailing)
            }
            
            // 顯示搜尋建議
            if !suggestions.isEmpty {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(suggestions, id: \.self) { suggestion in
                            Text(suggestion)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    searchText = suggestion
                                    performSearch()
                                    suggestions = []
                                }
                        }
                    }
                }
                .frame(maxHeight: 200)
                .background(Color(.systemBackground))
                .shadow(radius: 2)
            }
            
            // 結果顯示區域
            ScrollView {
                if let result = searchResult {
                    DictionaryResultView(result: result)
                }
            }
        }
        .alert("查詢失敗", isPresented: $showError) {
            Button("確定", role: .cancel) { }
        }
        // 視圖出現時自動執行搜尋「萌」字
        .onAppear {
            performSearch()
        }
    }
    
    // 執行搜尋功能
    func performSearch() {
        guard let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let url = URL(string: "https://www.moedict.tw/uni/\(encodedText).json") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let result = try JSONDecoder().decode(DictResponse.self, from: data)
                        self.searchResult = result
                    } catch {
                        self.showError = true
                    }
                } else {
                    self.showError = true
                }
            }
        }.resume()
    }
}

#Preview {
    ContentView()
}
