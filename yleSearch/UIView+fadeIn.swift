//
//  UIView+fadeIn.swift
//  yleSearch
//
//  Created by Oleksandr Shcherbonos on 4/5/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import UIKit

extension UIView {
    func fadeIn(in animationTime: Double) {
        self.alpha = 0
        UIView.animate(withDuration: animationTime) {
            self.alpha = 1
        }
    }
}
