//
//  Yolov3Detector.swift
//  mlLibraryDemo
//
//  Created by ryosism on 2024/08/18.
//

import Foundation

import Vision
import CoreML
import UIKit
import VideoToolbox

final class Yolov3Detector {
    public static let shared = Yolov3Detector()
    let model: VNCoreMLModel

    private init() {
        self.model = try! VNCoreMLModel(for: YOLOv3TinyInt8LUT(configuration: .init()).model)
    }

    func predict(input: CGImage) -> CGImage? {
        let request = VNCoreMLRequest(model: model)
        request.preferBackgroundProcessing = true
        request.imageCropAndScaleOption = .centerCrop

        let handler = VNImageRequestHandler(cgImage: input)
        try! handler.perform([request])

        /// resultsのリストを見るとさまざまなタスクの結果を格納するclassが集まっている
        /// その中の1つである、featureの形で格納されているclassで
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
            case let detection as VNRecognizedObjectObservation:
                let labels: [VNClassificationObservation] = detection.labels
                let top3Labels: [VNClassificationObservation] = Array(detection.labels[0..<2])
                print("print(\(top3Labels), bbox = [\(detection.boundingBox)]")
                return nil
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
