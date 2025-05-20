
# 📱 iOS Real-time Object Identifier

**Object Identifier** is a real-time object recognition app that leverages CoreML and Vision to classify objects through the camera feed using the MobileNetV2 model.

## 🚀 Features

- Live object detection from the device camera
- Real-time CoreML classification with Vision framework
- Permission handling with user-friendly prompts
- SwiftUI-based UI with seamless UIKit integration
- Displays object name and confidence score in real-time

## 🛠 Technologies Used

- **SwiftUI** – Declarative UI framework for modern iOS development
- **AVFoundation** – Captures video feed from the device camera
- **Vision + CoreML** – For processing and classifying visual data
- **UIKit (UIViewRepresentable)** – For camera preview rendering
- **Swift Macros (@Observable, @Bindable)** – For reactive state management

## 🧠 Machine Learning Model

The app uses Apple’s pre-trained **MobileNetV2** CoreML model, known for its efficient and lightweight object classification capabilities.

📸 Live Camera Preview
Camera feed is displayed using AVCaptureVideoPreviewLayer inside a custom UIView subclass (PreviewView) and bridged into SwiftUI via UIViewRepresentable.

🔐 Camera Permissions
The app checks and requests camera permissions at runtime. If denied, it provides an option to open system settings:


📲 How to Run
Clone the repository:
```bash
git clone https://github.com/berkakkerman/Identifier.git
```
```bash
cd Identifier
```
```bash
open Identifier.xcodeproj
```

Feel free to contribute or use
