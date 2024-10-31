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
//                        .transition(.opacity)
//                        .padding(.vertical)
                } else {
                    ContentUnavailableView(
                        "萌典2.0",
                        systemImage: "character.book.closed",
                        description: Text("輸入中文字詞開始查詢")
                        
                    )
                    Spacer()
                    
                    // 版權資訊
                    CopyrightLabel().padding(.bottom, 8)
                }
                
                
            }
//            .ignoresSafeArea(.all, edges: .bottom)
//            .background(.background)
            .navigationTitle("萌典2.0")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.visible, for: .navigationBar)
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer,
                prompt: "搜尋字詞"
            )
            .onSubmit(of: .search, performSearch)
            .onChange(of: searchText) { newValue in
                // 取得更多建議（最多顯示 15 個）
                if let firstChar = newValue.first.map(String.init) {
                    suggestions = [firstChar] + wordIndex.getSuggestions(for: newValue, limit: 14)
                        .filter { $0 != firstChar }
                } else {
                    suggestions = wordIndex.getSuggestions(for: newValue, limit: 15)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification)) { _ in
                if searchText.contains("\n") {
                    searchText = searchText.replacingOccurrences(of: "\n", with: "")
                    performSearch()
                }
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
            // 預設搜尋
            searchText = "和"
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
