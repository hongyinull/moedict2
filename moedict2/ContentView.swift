//
//  ContentView.swift
// 實現簡單的萌典查詢介面

import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    @State private var searchResult: DictResponse?
    @State private var showError = false
    @State private var suggestions: [String] = []
    @StateObject private var wordIndex = WordIndex()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if let result = searchResult {
                    BigCardResultView(result: result)
                        .transition(.opacity)
                } else {
                    ContentUnavailableView(
                        "萌典",
                        systemImage: "character.book.closed",
                        description: Text("輸入中文字詞開始查詢")
                    )
                }
            }
            .background(.ultraThinMaterial)
            .navigationTitle("萌典")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.visible, for: .navigationBar)
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer,
                prompt: "搜尋字詞"
            )
            .onSubmit(of: .search, performSearch)
            .onChange(of: searchText) { newValue in
                suggestions = wordIndex.getSuggestions(for: newValue)
            }
            .searchSuggestions {
                if !suggestions.isEmpty {
                    ForEach(suggestions, id: \.self) { suggestion in
                        Text(suggestion)
                            .searchCompletion(suggestion)
                    }
                }
            }
        }
        .alert("查詢失敗", isPresented: $showError) {
            Button("確定", role: .cancel) { }
        } message: {
            Text("請確認網路連線並重試")
        }
        .onAppear {
            // 移除預設搜尋，讓使用者主動搜尋
            searchText = ""
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
