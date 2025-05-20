//
//  ContentView.swift
//  Identifier
//
//  Created by Berk Akkerman on 20.05.2025.
//

import SwiftUI

struct ContentView: View {
    
    @Bindable var model = CameraModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if model.isSessionReady, model.isPermissionGranted, let previewLayer = model.previewLayer {
                CameraPreviewView(session: model.session, previewLayer: previewLayer)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                VStack(spacing: 8) {
                    Text("🎯 Detected: \(model.detectedObject)")
                        .font(.title2)
                        .bold()
                    
                    Text("📊 Confidence: \(model.confidence, specifier: "%.2f")")
                        .font(.subheadline)
                        .opacity(0.9)
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(LinearGradient(colors: [.white.opacity(0.3), .clear], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
                .padding()
                .foregroundStyle(.white)
                
            } else {
                VStack(spacing: 20) {
                    ContentUnavailableView(
                        "Camera not available",
                        systemImage: "camera",
                        description: Text("Please ensure camera permissions are granted and try again.")
                    )
                    
                    if !model.isPermissionGranted {
                        Button(action: {
                            model.requestCameraPermission()
                        }) {
                            Text("Request Camera Permission")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    Color.black
                                )
                                .cornerRadius(16)
                                .shadow(color: .white.opacity(0.05), radius: 3, x: -2, y: -2)
                                .shadow(color: .black.opacity(0.8), radius: 6, x: 4, y: 4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                        }
                        .padding(.horizontal)


                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
