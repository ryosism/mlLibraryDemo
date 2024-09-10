//
//  Yolov3View.swift
//  mlLibraryDemo
//
//  Created by ryosism on 2024/08/18.
//

import SwiftUI

struct Yolov3View: View {
    @State var isPredicating: Bool = false
    @State var predicatedImage: CGImage?

    var body: some View {
        VStack {
            Image("detectionSample")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 32)
            Button {
                guard let image = UIImage(named: "detectionSample"), let cgImage = image.cgImage else { return }
                predicatedImage = Yolov3Detector.shared.predict(input: cgImage)
            } label: {
                Text("Push to predicate")
            }
            if let predicatedImage {
                Image(predicatedImage, scale: 1, label: Text("predicated"))
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 32)
            } else {
                Rectangle()
                    .foregroundStyle(.gray)
                    .padding(.horizontal, 32)
            }
            Spacer()
        }
    }
}

#Preview {
    Yolov3View()
}
