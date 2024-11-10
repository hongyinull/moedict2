//
//  WelcomeView.swift
//  HakkaShopScanner
//
//  Created by HONGYINULL on 2024/10/5.
//

import Foundation
import SwiftUI

struct WelcomeView: View {
    @Binding var showWelcomeScreen: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Text("歡迎使用")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            Text("萌典2")
                .font(.largeTitle)
                .fontWeight(.bold)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("快速查詢中文字詞的意義")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            Spacer()
            
            VStack(spacing: 24) {
                FeatureCell(
                    image: "books.vertical.fill",
                    title: "三種辭典",
                    subtitle: "支援國語、閩南語、客語查詢",
                    color: .accentColor
                )
                FeatureCell(
                    image: "book.pages.fill",
                    title: "完整釋義",
                    subtitle: "包含讀音、部首、筆畫等詳細資訊",
                    color: .accentColor
                )
                FeatureCell(
                    image: "globe.asia.australia.fill",
                    title: "多語翻譯",
                    subtitle: "提供英語等多國語言對照翻譯",
                    color: .accentColor
                )
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 50)
            
            Spacer()
            
            Button(action: {
                showWelcomeScreen = false
                // 使用可選綁定（optional binding）來安全處理 URL
                if let url = URL(string: "https://line.me/ti/g2/NNRlE3iBmhR36rYfKzQlqAo9lIXgYJqDcZE0ow?utm_source=invitation&utm_medium=link_copy&utm_campaign=default") {
                    UIApplication.shared.open(url)
                }
            }) {
                Text("開始探索")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(10)
            }
            .padding()
            
            HStack(spacing: 20) {
                Button(action: {
                    if let url = URL(string: "https://github.com/g0v/moedict-webkit") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("專案資訊")
                        .font(.subheadline)
                        .foregroundColor(.accentColor)
                }
            }
            .padding(.top, 3)
        }
        .padding(.bottom, 5)
    }
}

struct FeatureCell: View {
    var image: String
    var title: String
    var subtitle: String
    var color: Color
    
    var body: some View {
        HStack(spacing: 24) {
            Image(systemName: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32)
                .foregroundColor(color)
                    
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(subtitle)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
            
            Spacer()
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(showWelcomeScreen: .constant(true))
    }
}
