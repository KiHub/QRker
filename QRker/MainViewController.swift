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
            appBackGroundColor.cgColor,
            UIColor.clear.cgColor,
            appBackGroundColor.cgColor
        ]
        return gradientLayer
    }()
    
    let overlay: UIImageView = {
        let overlay = UIImageView(frame: CGRect.zero)
        overlay.image = UIImage(named: "targetlight")
        overlay.contentMode = .scaleAspectFit
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.layer.shadowColor =  appBackGroundColor.cgColor
        overlay.layer.shadowOpacity = 0.7
        overlay.layer.shadowOffset = .init(width: 5, height: 5)
        overlay.layer.shadowRadius = 17
                return overlay
            }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupVideo()
        startRunning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gradient.frame = view.frame
        overlay.image = UIImage(named: "targetlight")
        session.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.stopRunning()
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
