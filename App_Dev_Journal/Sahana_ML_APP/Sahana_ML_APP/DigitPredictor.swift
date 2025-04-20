//
//  DigitalPredictor.Swift
//  Sahana_ML_APP
//
//  Created by Raghuraman, Sahana on 4/20/25.
//

import CoreML
import UIKit

class DigitPredictor {
    private let model = MNISTClassifier()

    func predict(image: UIImage) -> String? {
        // Step 1: Invert colors (MNIST expects white digits on black)
        guard let inverted = image.inverted(),
              let resized = inverted.resize(to: CGSize(width: 28, height: 28)),
              let buffer = resized.toGrayScaleBuffer() else {
            print("Failed to prepare image for prediction")
            return nil
        }

        do {
            let prediction = try model.prediction(image: buffer)
            return String(prediction.classLabel)
        } catch {
            print("Prediction error: \(error)")
            return nil
        }
    }
}

extension UIImage {
    /// Resize image to given size
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        draw(in: CGRect(origin: .zero, size: size))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }

    /// Invert colors to match MNIST black background with white digit
    func inverted() -> UIImage? {
        guard let ciImage = CIImage(image: self) else { return nil }
        let filter = CIFilter(name: "CIColorInvert")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        guard let outputCIImage = filter?.outputImage else { return nil }
        return UIImage(ciImage: outputCIImage)
    }

    /// Convert to grayscale CVPixelBuffer for CoreML model
    func toGrayScaleBuffer() -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                     kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var buffer: CVPixelBuffer?
        let width = Int(self.size.width)
        let height = Int(self.size.height)

        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         width,
                                         height,
                                         kCVPixelFormatType_OneComponent8,
                                         attrs,
                                         &buffer)

        guard status == kCVReturnSuccess, let resultBuffer = buffer else {
            print("Failed to create CVPixelBuffer")
            return nil
        }

        CVPixelBufferLockBaseAddress(resultBuffer, [])
        let context = CGContext(data: CVPixelBufferGetBaseAddress(resultBuffer),
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: CVPixelBufferGetBytesPerRow(resultBuffer),
                                space: CGColorSpaceCreateDeviceGray(),
                                bitmapInfo: CGImageAlphaInfo.none.rawValue)

        guard let cgImage = self.cgImage else {
            print("UIImage to CGImage conversion failed")
            CVPixelBufferUnlockBaseAddress(resultBuffer, [])
            return nil
        }

        context?.draw(cgImage, in: CGRect(origin: .zero, size: self.size))
        CVPixelBufferUnlockBaseAddress(resultBuffer, [])

        return resultBuffer
    }
}
