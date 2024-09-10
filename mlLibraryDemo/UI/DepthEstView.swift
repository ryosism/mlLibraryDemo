//
//  DepthEstView.swift
//  mlLibraryDemo
//
//  Created by ryosism on 2024/07/21.
//

import SwiftUI

struct DepthEstView: View {
    @State var isPredicating: Bool = false
    @State var predicatedImage: CGImage?
    let inputImage: UIImage? = UIImage(named: "depthSample")

    var body: some View {
        VStack {
            if let cgImage = inputImage?.cgImage {
                Image(cgImage, scale: 1, label: Text("input"))
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 32)
            }
            Button {
                guard let image = UIImage(named: "depthSample"), let cgImage = image.cgImage else { return }
                predicatedImage = DepthPredictor.shared.predict(input: cgImage)
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
    DepthEstView()
}
