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
  
  private lazy var captureSession = AVCaptureSession()
  
  private lazy var videoPreviewLayer: AVCaptureVideoPreviewLayer? = {
    let discoverySession = AVCaptureDevice.DiscoverySession(
      deviceTypes: [.builtInDualCamera],
      mediaType: .video,
      position: .back
    )

    guard let captureDevice = discoverySession.devices.first,
      let deviceInput = try? AVCaptureDeviceInput(device: captureDevice)
    else { return nil }
    
    captureSession.addInput(deviceInput)
    captureSession.sessionPreset = .photo
    captureSession.startRunning()
    
    return AVCaptureVideoPreviewLayer(session: captureSession)
  } ()
  
  private lazy var cameraView: UIView = {
    guard let previewLayer = videoPreviewLayer else { return UIView() }
    
    let bounds = view.bounds
    previewLayer.bounds = bounds
    previewLayer.position = .init(x: bounds.midX, y: bounds.midY)
    previewLayer.videoGravity = .resizeAspectFill
    
    let frame = CGRect(origin: .zero, size: bounds.size)
    let cameraPreview = UIView(frame: frame)
    cameraPreview.layer.addSublayer(previewLayer)
    
    return cameraPreview
  } ()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(cameraView)
  }
  
}
