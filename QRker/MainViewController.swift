//
//  ViewController.swift
//  QRker
//
//  Created by  Mr.Ki on 04.05.2022.
//

import UIKit
import AVFoundation
import SafariServices

class MainViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var video = AVCaptureVideoPreviewLayer()
    //MARK: - Set session
    let session = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideo()
        
        startRunning()
        
    }
    
    func setupVideo() {
        //MARK: - Set video
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        //MARK: - Set input
        do {
            guard let device = captureDevice else {return}
            let input = try AVCaptureDeviceInput(device: device)
            session.addInput(input)
        } catch {
            fatalError(error.localizedDescription)
        }
        //MARK: - Set output
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
    }
    
    func startRunning() {
        view.layer.addSublayer(video)
        session.startRunning()
    }
    
    
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard metadataObjects.count > 0 else { return }
        if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            if object.type == AVMetadataObject.ObjectType.qr {
                let alert = UIAlertController(title: "QR Code", message: object.stringValue, preferredStyle: .alert)
                
                
                alert.addAction(UIAlertAction(title: "Link", style: .default, handler: { (action) in
                    guard let url = URL(string: object.stringValue ?? "https://google.com") else {return}
                    let configuration = SFSafariViewController.Configuration()
                    let safariViewController = SFSafariViewController(url: url, configuration: configuration)
                    safariViewController.modalPresentationStyle = .fullScreen
                    safariViewController.preferredControlTintColor = appMainColor
                    safariViewController.preferredBarTintColor = appBackGroundColor
                    self.present(safariViewController, animated: true)
                    print(object.stringValue)
                }))
                
                
                alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: { (action) in
                    UIPasteboard.general.string = object.stringValue
                    //  self.view.layer.sublayers?.removeLast()
                    // self.session.stopRunning()
                    print(object.stringValue)
                }))
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
}


