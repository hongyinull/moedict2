//
//  moedict2App.swift
//  moedict2
//
//  Created by HONGYINULL on 2024/10/30.
//

import SwiftUI

@main
struct moedict2App: App {
    init() {
        // 設定全域 AccentColor
        UIView.appearance().tintColor = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
