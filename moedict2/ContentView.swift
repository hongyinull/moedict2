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
    
    // 新增語言選擇的列舉和狀態變數
    enum DictType: String, CaseIterable {
        case mandarin = "國語"
        case taiwanese = "閩南語"
        case hakka = "客語"
        
        // 取得對應的 URL 前綴
        var urlPrefix: String {
            switch self {
            case .mandarin: return "uni"
            case .taiwanese: return "t"
            case .hakka: return "h"
            }
        }
    }
    
    @State private var selectedDict: DictType = .mandarin
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Picker("字典選擇", selection: $selectedDict) {
                            ForEach(DictType.allCases, id: \.self) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "book")
                            Text(selectedDict.rawValue)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.accentColor.opacity(0.2))
                        .cornerRadius(8)
                    }
                }
            }
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer,
                prompt: "搜尋字詞"
            )
//            .offset(y: 15)
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
    
    // 修改搜尋功能以支援不同的字典
    func performSearch() {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        guard let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let url = URL(string: "https://www.moedict.tw/\(selectedDict.urlPrefix)/\(encodedText).json") else {
            print("URL 創建失敗")
            self.showError = true
            return
        }
        
        print("開始查詢：\(url.absoluteString)")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("網路錯誤：\(error.localizedDescription)")
                    self.showError = true
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    print("HTTP 錯誤：\(String(describing: response))")
                    self.showError = true
                    return
                }
                
                guard let data = data else {
                    print("沒有收到數據")
                    self.showError = true
                    return
                }
                
                do {
                    // 先嘗試解析原始 JSON 以便偵錯
                    if let json = try? JSONSerialization.jsonObject(with: data) {
                        print("收到的 JSON：\(json)")
                    }
                    
                    let result = try JSONDecoder().decode(DictResponse.self, from: data)
                    guard !result.heteronyms.isEmpty else {
                        print("heteronyms 為空")
                        self.showError = true
                        return
                    }
                    
                    self.searchResult = result
                    print("成功解析結果：\(result.title)")
                } catch {
                    print("JSON 解碼錯誤：\(error)")
                    self.showError = true
                }
            }
        }.resume()
    }
}

#Preview {
    ContentView()
}
