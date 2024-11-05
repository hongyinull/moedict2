// NormalResultView.swift
// 處理字典搜尋結果的顯示視圖

import SwiftUI


struct NormalResultView: View {
    let result: DictResponse
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 標題區域
            HStack(alignment: .bottom, spacing: 12) {
                Text(result.title)
                    .font(.system(size: 36, weight: .bold))
                
                if let radical = result.radical, let strokeCount = result.strokeCount {
                    Text("部首：\(radical) ・ \(strokeCount)畫")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            // 釋義區域
            ForEach(result.heteronyms.indices, id: \.self) { index in
                let heteronym = result.heteronyms[index]
                VStack(alignment: .leading, spacing: 8) {
                    // 注音和拼音
                    HStack(spacing: 12) {
                        if let bopomofo = heteronym.bopomofo {
                            Text(bopomofo)
                                .font(.system(size: 18))
                        }
                        if let pinyin = heteronym.pinyin {
                            Text(pinyin)
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // 定義列表
                    ForEach(heteronym.definitions.indices, id: \.self) { defIndex in
                        let def = heteronym.definitions[defIndex]
                        VStack(alignment: .leading, spacing: 6) {
                            // 詞性和定義
                            HStack(alignment: .top) {
                                if let type = def.type {
                                    Text("【\(type)】")
                                        .foregroundColor(.gray)
                                }
                                Text(def.def)
                            }
                            
                            // 例句
                            if let examples = def.example {
                                ForEach(examples, id: \.self) { example in
                                    Text(example)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .padding(.leading)
                                }
                            }
                            
                            // 引用
                            if let quotes = def.quote {
                                ForEach(quotes, id: \.self) { quote in
                                    Text(quote)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .padding(.leading)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding(.vertical, 8)
                
                if index < result.heteronyms.count - 1 {
                    Divider()
                }
            }
        }
        .padding()
    }
} 
