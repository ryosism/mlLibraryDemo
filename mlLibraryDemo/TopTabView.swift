//
//  TopTabView.swift
//  mlLibraryDemo
//
//  Created by ryosism on 2024/07/13.
//

import SwiftUI

struct TopTabView: View {
    @State var selection = 1

    var body: some View {
        TabView(selection: $selection) {
            TopMLListView()
                .tabItem {
                    Label("MLModelリスト", systemImage: "1.circle")
                }
                .tag(1)
            ToolView()
                .tabItem {
                    Label("その他", systemImage: "2.circle")
                }
                .tag(2)
        }
    }
}

#Preview {
    TopTabView()
}
