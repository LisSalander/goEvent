//
//  DesignableView.swift
//  goEventS
//
//  Created by vika on 10/11/17.
//  Copyright © 2017 VikaMaksymuk. All rights reserved.
//

import UIKit

@IBDesignable class DesignableView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 15 {
        didSet {
        self.layer.cornerRadius = cornerRadius
        }
    }

}
