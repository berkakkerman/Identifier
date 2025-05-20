//
//  CameraModel.swift
//  Identifier
//
//  Created by Berk Akkerman on 20.05.2025.
//
import AVFoundation
import Observation
import Vision
import CoreML
import UIKit

@Observable
class CameraModel: NSObject {
    
    var session: AVCaptureSession = .init()
    var previewLayer: AVCaptureVideoPreviewLayer?
    var detectedObject: String = ""
    var confidence: Float = 0.0
    var isSessionReady = false
    var isPermissionGranted = false

    override init() {
        super.init()
        checkPermission()
    }

    private func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            isPermissionGranted = true
            configureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    self?.isPermissionGranted = granted
                    if granted {
                        self?.configureSession()
                    } else {
                        print("Camera permission denied by user")
                    }
                }
            }
        default:
            isPermissionGranted = false
            print("Camera permission denied")
        }
    }

    func requestCameraPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    self?.isPermissionGranted = granted
                    if granted {
                        self?.configureSession()
                    } else {
                        print("Camera permission denied by user")
                    }
                }
            }
        case .denied, .restricted:
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:]) { success in
                    print("Opened Settings: \(success)")
                }
            }
        default:
            break
        }
    }

    private func configureSession() {
        guard isPermissionGranted else {
            print("Permission not granted, cannot configure session")
            return
        }

        session.beginConfiguration()
        defer { session.commitConfiguration() }

        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else {
            print("Failed to create capture device or input")
            return
        }

        if session.canAddInput(input) {
            session.addInput(input)
        } else {
            print("Cannot add input to session")
            return
        }

        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: .global(qos: .userInitiated))
        if session.canAddOutput(output) {
            session.addOutput(output)
        } else {
            print("Cannot add output to session")
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
            DispatchQueue.main.async {
                self.previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
                self.previewLayer?.videoGravity = .resizeAspectFill
                self.isSessionReady = true
                print("Session started: \(self.session.isRunning)")
            }
        }
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension CameraModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("Failed to get pixel buffer")
            return
        }

        let config = MLModelConfiguration()
        guard let mlModel = try? MobileNetV2(configuration: config).model,
              let visionModel = try? VNCoreMLModel(for: mlModel) else {
            print("Failed to load machine learning model")
            return
        }

        let request = VNCoreMLRequest(model: visionModel) { [weak self] request, _ in
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                print("No classification results")
                return
            }

            DispatchQueue.main.async {
                self?.detectedObject = topResult.identifier
                self?.confidence = topResult.confidence
                print("Detected: \(topResult.identifier), Confidence: \(topResult.confidence)")
            }
        }

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print("Vision request failed: \(error)")
        }
    }
}
