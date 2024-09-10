//
//  SemaSegView.swift
//  mlLibraryDemo
//
//  Created by ryosism on 2024/07/21.
//

import SwiftUI

struct SemaSegView: View {
    @State var isPredicating: Bool = false
    @State var predicatedImage: CGImage?

    var body: some View {
        VStack {
            Image("semasegSample")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 32)
            Button {
                guard let image = UIImage(named: "semasegSample"), let cgImage = image.cgImage else { return }
                predicatedImage = SemasegPredictor.shared.predict(input: cgImage)
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
    SemaSegView()
}
