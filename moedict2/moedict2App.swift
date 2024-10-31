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
        let accentColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 153/255, green: 31/255, blue: 34/255, alpha: 1)  // 暗色模式
            : UIColor(red: 107/255, green: 0/255, blue: 6/255, alpha: 1)    // 亮色模式
        }
        UIView.appearance().tintColor = accentColor
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
