//
//  SemasegPredictor.swift
//  mlLibraryDemo
//
//  Created by ryosism on 2024/08/18.
//

import Foundation
import Vision
import CoreML
import UIKit
import VideoToolbox

final class SemasegPredictor {
    public static let shared = SemasegPredictor()
    let model: VNCoreMLModel


    private init() {
        self.model = try! VNCoreMLModel(for: DETRResnet50SemanticSegmentationF16().model)
    }

    func predict(input: CGImage) -> CGImage? {
        let request = VNCoreMLRequest(model: model)
        request.preferBackgroundProcessing = true
        request.imageCropAndScaleOption = .centerCrop

        let handler = VNImageRequestHandler(cgImage: input)
        try! handler.perform([request])

        /// resultsのリストを見るとさまざまなタスクの結果を格納するclassが集まっている
        /// Fully Convolution層の出力なのでfeature mapで格納されているclassで結果を受け取る
        if let result = request.results?.first {
            switch result {
                case let feature as VNCoreMLFeatureValueObservation:
                    if let array = feature.featureValue.multiArrayValue {
                        let cgImage = array.cgImage(min: 0, max: 255, channel: 3)
                        return cgImage
                    } else {
                        print("Analize failed multiArrayValue = : \(feature)")
                        return nil
                    }
            case let buffer as VNPixelBufferObservation:
                print("pixelBuffer: \(buffer.pixelBuffer)")
                let cgImage = CGImage.create(pixelBuffer: buffer.pixelBuffer)
                return cgImage
            default:
                print("Analize failed : \(result)")
                    return nil
            }
        } else {
            print("Prediction failed : \(String(describing: request.results?.debugDescription))")
            return nil
        }
    }
}
