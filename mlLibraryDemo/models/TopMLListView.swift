//
//  ContentView.swift
//  mlLibraryDemo
//
//  Created by ryosism on 2024/07/13.
//

import SwiftUI

struct TopMLListView: View {

    var body: some View {
        NavigationStack {
            List {
                NavigationLink("SemaSeg") {
                    SemaSegView()
                        .navigationTitle("SemaSeg")
                }
                NavigationLink("DepthEstmation") {
                    DepthEstView()
                        .navigationTitle("DepthEst")
                }
                NavigationLink("YoloV3") {
                    Yolov3View()
                        .navigationTitle("DepthEst")
                }
            }.navigationTitle("🤗 Models")
        }
    }
}

#Preview {
    TopMLListView()
}
