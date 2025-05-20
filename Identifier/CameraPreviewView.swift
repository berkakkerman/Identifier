//
//  CameraPreviewView.swift
//  Identifier
//
//  Created by Berk Akkerman on 20.05.2025.
//

import SwiftUI
import AVFoundation

struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession
    let previewLayer: AVCaptureVideoPreviewLayer?

    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        if let previewLayer = previewLayer {
            view.previewLayer = previewLayer
            view.layer.addSublayer(previewLayer)
            if let connection = previewLayer.connection {
                connection.videoRotationAngle = 90
            }
        }
        return view
    }

    func updateUIView(_ uiView: PreviewView, context: Context) {}
}

class PreviewView: UIView {
    var previewLayer: AVCaptureVideoPreviewLayer?

    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = bounds
        print("PreviewView bounds: \(bounds), preview layer frame: \(previewLayer?.frame ?? CGRect.zero)")
    }
}
