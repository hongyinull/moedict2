//
//  WelcomeView.swift
//  HakkaShopScanner
//
//  Created by HONGYINULL on 2024/10/5.
//

import Foundation
import SwiftUI

struct WelcomeScreen: View {
    @Binding var showWelcomeScreen: Bool
    @Environment(\.presentationMode) var presentationMode
    @State public var showDisclaimer = false
    @State public var showReference = false
    
    var body: some View {
        VStack {
            Spacer()
            Text("歡迎使用")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            Text("Posture Risk")
                .font(.largeTitle)
                .fontWeight(.bold)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("快速評估你的姿勢風險")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            Spacer()
            
            VStack(spacing: 24) {
                FeatureCell(image: "figure.walk", title: "即時姿勢追蹤", subtitle: "在 AR 空間中即時捕捉人體姿勢", color: .accentColor)
                FeatureCell(image: "chart.bar.fill", title: "REBA 評分", subtitle: "快速計算並顯示姿勢的風險評分", color: .accentColor)
                FeatureCell(image: "ruler.fill", title: "身體測量", subtitle: "自動測量關節角度和身體部位距離", color: .accentColor)
                FeatureCell(image: "person.fill.viewfinder", title: "多種顯示方式", subtitle: "自由切換 3D 模型和骨架模式", color: .accentColor)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal,50)
            
            Spacer()
            
            Button(action: {
                showWelcomeScreen = false
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("開始探索")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(10)
            }
            .padding()
            
            HStack(spacing: 20) {
                Button(action: {
                    if let url = URL(string: "https://www.instagram.com/boiling_bo/") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("作者資訊")
                        .font(.subheadline)
                        .foregroundColor(.accentColor)
                }
                
                Button(action: { showDisclaimer.toggle() }) {
                    Text("醫療免責聲明")
                        .font(.subheadline)
                        .foregroundColor(.accentColor)
                }
                .sheet(isPresented: $showDisclaimer) {
                    DisclaimerView()
                }
                
                Button(action: { showReference.toggle() }) {
                    Text("資訊來源")
                        .font(.subheadline)
                        .foregroundColor(.accentColor)
                }
                .sheet(isPresented: $showReference) {
                    ReferenceView()
                }
            }
            .padding(.top, 3)
        }
        .padding(.bottom,5)
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

// 預覽提供者
struct WelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreen(showWelcomeScreen: .constant(true))
    }
}
