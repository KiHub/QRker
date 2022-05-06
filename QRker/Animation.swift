//
//  Animation.swift
//  QRker
//
//  Created by  Mr.Ki on 06.05.2022.
//


import UIKit

class Animation {
    func shake(view: UIView) {
    let animation = CAKeyframeAnimation()
    animation.keyPath = "position.x"
    animation.values = [0, 15, -10, 15, 0]
    animation.keyTimes = [0, 0.16, 0.5, 0.83, 1]
    animation.duration = 0.4
    animation.isAdditive = true
    view.layer.add(animation, forKey: "shake")
    }
}
