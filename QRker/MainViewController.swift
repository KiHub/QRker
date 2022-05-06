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
    let animation = Animation()
    
    let gradient: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            appSecondColor.cgColor,
            UIColor.clear.cgColor,
            appSecondColor.cgColor
            // UIColor.systemBackground.cgColor
        ]
        
        
        return gradientLayer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupVideo()
        
        startRunning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startRunning()
        gradient.frame = view.frame
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.stopRunning()
    }
    
    func setup() {
        
        
        
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
        video.videoGravity = .resizeAspectFill
    }
    
    func startRunning() {
        view.layer.addSublayer(video)
        session.startRunning()
    }
    
    
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard metadataObjects.count > 0 else { return }
        if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            if object.type == AVMetadataObject.ObjectType.qr {
                allert(title: "QR", message: object.stringValue ?? "https://google.com")
                self.view.layer.addSublayer(gradient)
                
            }
        }
    }
    
    
}

extension MainViewController {
    func allert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.view.tintColor = appMainColor
        
        if message.hasPrefix("http") {
            alert.addAction(UIAlertAction(title: "Link", style: .default, handler: { (action) in
                guard let url = URL(string: message) else {return}
                let configuration = SFSafariViewController.Configuration()
                let safariViewController = SFSafariViewController(url: url, configuration: configuration)
                safariViewController.modalPresentationStyle = .fullScreen
                safariViewController.preferredControlTintColor = appMainColor
                safariViewController.preferredBarTintColor = appBackGroundColor
                self.present(safariViewController, animated: true)
                self.view.layer.sublayers = nil
                self.gradient.removeFromSuperlayer()
            }))
        }
        
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            
            self.addNewsToList(url: message)
            self.gradient.removeFromSuperlayer()
            self.gradient.removeFromSuperlayer()
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: { (action) in
            UIPasteboard.general.string = message
            self.gradient.removeFromSuperlayer()
            
        }))
        present(alert, animated: true, completion: nil)
    }
}


extension MainViewController {
    
    func addNewsToList(url: String) {
        CoreDataManager.shared.downloadNewsToDataBase(model: url ) { result in
            switch result {
            case .success():
                print("Downloaded to DB")
                NotificationCenter.default.post(name: NSNotification.Name("loaded"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
