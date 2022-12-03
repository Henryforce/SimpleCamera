//
//  ViewController.swift
//  SimpleCamera
//
//  Created by Henry Javier Serrano Echeverria on 7/10/22.
//

import UIKit
import AVFoundation

/// Controller for a simple camera. Passthrough video only. No actions.
final class ViewController: UIViewController {
  
  private let captureDevices: [AVCaptureDevice.DeviceType]
  
  private lazy var captureSession = AVCaptureSession()
  
  private lazy var videoPreviewLayer: AVCaptureVideoPreviewLayer? = {
    let discoverySession = AVCaptureDevice.DiscoverySession(
      deviceTypes: captureDevices,
      mediaType: .video,
      position: .back
    )

    guard let captureDevice = discoverySession.devices.first,
      let deviceInput = try? AVCaptureDeviceInput(device: captureDevice)
    else { return nil }
    
    let captureSession = self.captureSession
    captureSession.addInput(deviceInput)
    captureSession.sessionPreset = .photo
    DispatchQueue.global().async {
      captureSession.startRunning()
    }
    
    return AVCaptureVideoPreviewLayer(session: captureSession)
  } ()
  
  private lazy var cameraView: UIView = {
    guard let previewLayer = videoPreviewLayer else {
      return errorLabel
    }
    
    let bounds = view.bounds
    previewLayer.bounds = bounds
    previewLayer.position = .init(x: bounds.midX, y: bounds.midY)
    previewLayer.videoGravity = .resizeAspectFill
    
    let frame = CGRect(origin: .zero, size: bounds.size)
    let cameraPreview = UIView(frame: frame)
    cameraPreview.layer.addSublayer(previewLayer)
    
    return cameraPreview
  } ()
  
  private lazy var errorLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "The camera could not be loaded..."
    label.font = .preferredFont(forTextStyle: .caption1)
    label.textAlignment = .center
    return label
  } ()

  init(captureDevices: [AVCaptureDevice.DeviceType]) {
    self.captureDevices = captureDevices
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(cameraView)

    // If ny
    if cameraView is UILabel {
      NSLayoutConstraint.activate([
        errorLabel.heightAnchor.constraint(equalToConstant: 50),
        errorLabel.widthAnchor.constraint(equalToConstant: 220),
        errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      ])
    }
  }
  
}
