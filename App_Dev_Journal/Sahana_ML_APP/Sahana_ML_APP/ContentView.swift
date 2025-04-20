//
//  ContentView.swift
//  Sahana_ML_APP
//
//  Created by Raghuraman, Sahana on 4/20/25.
//

import SwiftUI

struct ContentView: View {
    @State private var prediction: String = "Draw a digit"
    @State private var drawnImage: UIImage?
    @State private var clearCanvas: Bool = false

    var body: some View {
        VStack {
            DrawingPad(drawnImage: $drawnImage, clearTrigger: $clearCanvas)
                .frame(width: 300, height: 300)
                .border(Color.black)

            HStack {
                Button("Predict") {
                    predictDigit()
                }
                .padding()

                Button("Clear") {
                    clearCanvas = true
                    drawnImage = nil
                    prediction = "Draw a digit"
                }
                .padding()
            }

            Text(prediction)
                .font(.largeTitle)
                .padding()
        }
    }

    func predictDigit() {
        guard let image = drawnImage else {
            prediction = "No drawing found"
            return
        }

        let predictor = DigitPredictor()
        if let digit = predictor.predict(image: image) {
            prediction = "Predicted: \(digit)"
        } else {
            prediction = "Prediction failed"
        }
    }
}

struct DrawingPad: UIViewRepresentable {
    @Binding var drawnImage: UIImage?
    @Binding var clearTrigger: Bool

    class Coordinator: NSObject {
        var path = UIBezierPath()
        var parent: DrawingPad

        init(parent: DrawingPad) {
            self.parent = parent
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .white

        let pan = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.panGesture(_:)))
        imageView.addGestureRecognizer(pan)

        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {
        if clearTrigger {
            uiView.image = nil
            context.coordinator.path.removeAllPoints()
            DispatchQueue.main.async {
                clearTrigger = false
            }
        }
    }
}

extension DrawingPad.Coordinator {
    @objc func panGesture(_ gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view as? UIImageView else { return }
        let point = gesture.location(in: view)

        if gesture.state == .began {
            path.move(to: point)
        } else {
            path.addLine(to: point)
        }

        drawPath(in: view)
    }

    func drawPath(in imageView: UIImageView) {
        UIGraphicsBeginImageContext(imageView.frame.size)
        imageView.image?.draw(in: imageView.bounds)
        UIColor.black.setStroke()
        path.stroke()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        imageView.image = image
        parent.drawnImage = image
    }
}
