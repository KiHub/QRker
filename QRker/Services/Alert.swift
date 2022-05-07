//
//  Alert.swift
//  QRker
//
//  Created by  Mr.Ki on 07.05.2022.
//

import UIKit
import SafariServices

extension MainViewController {
    func alert(title: String, message: String) {
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
                self.gradient.removeFromSuperlayer()
            }))
        }
        
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            
            self.addNewsToList(url: message)
            self.gradient.removeFromSuperlayer()
            self.gradient.removeFromSuperlayer()
            self.overlay.image = UIImage(named: "targetlight")
            self.session.startRunning()
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: { (action) in
            UIPasteboard.general.string = message
            self.gradient.removeFromSuperlayer()
            self.overlay.image = UIImage(named: "targetlight")
            self.session.startRunning()
        }))
        present(alert, animated: true, completion: nil)
    }
}
