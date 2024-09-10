//
//  DepthPredictor.swift
//  mlLibraryDemo
//
//  Created by ryosism on 2024/08/11.
//

import Foundation
import Vision
import CoreML
import UIKit
import VideoToolbox

final class DepthPredictor {
    public static let shared = DepthPredictor()
    let model: VNCoreMLModel


    private init() {
        self.model = try! VNCoreMLModel(for: DepthAnythingV2SmallF16P6().model)
    }

    func predict(input: CGImage) -> CGImage? {
        let request = VNCoreMLRequest(model: model)
        request.preferBackgroundProcessing = true
        request.imageCropAndScaleOption = .centerCrop

        let handler = VNImageRequestHandler(cgImage: input)
        try! handler.perform([request])

        if let result = request.results?.first {
            /// resultsのリストを見るとさまざまなタスクの結果を格納するclassが集まっている
            switch result {
            case let feature as VNCoreMLFeatureValueObservation:
                if let array = feature.featureValue.multiArrayValue {
                    let cgImage = array.cgImage(min: 0, max: 255)
                    return cgImage
                } else {
                    print("Analize failed multiArrayValue = : \(feature)")
                    return nil
                }
            case let buffer as VNPixelBufferObservation:
                print("pixelBuffer: \(buffer.pixelBuffer)")
                let cgImage = CGImage.create(pixelBuffer: buffer.pixelBuffer)
                var output: CGImage?
                VTCreateCGImageFromCVPixelBuffer(buffer.pixelBuffer, options: nil, imageOut: &output)
                guard let output else { return nil }
                return output
            default:
                print("Analize failed : \(result)")
                return nil
            }
        } else {
            print("Prediction failed : \(request.results?.debugDescription)")
            return nil
        }
    }
}
