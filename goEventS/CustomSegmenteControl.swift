//
//  CustomSegmenteControl.swift
//  goEventS
//
//  Created by vika on 7/18/17.
//  Copyright © 2017 VikaMaksymuk. All rights reserved.
//

import UIKit

@IBDesignable
class CustomSegmenteControl: UIControl {
    private var labels = [UILabel]()
    var view = UIView()
    
    var items:[String] = [""]{
        didSet{
            setupAllLabels()
        }
    }
    func setupAllLabels(){
        for l in labels {
            l.removeFromSuperview()
        }
        labels.removeAll(keepingCapacity:true)
        for index in 1...items.count{
            let label = UILabel(frame:CGRect.zero)
            label.text = items[index - 1]
            label.textAlignment = .center
            label.textColor = UIColor.white
            self.addSubview(label)
            labels.append(label)
        }
    }
    var selectedIndex: Int = 0{
        didSet{
            selectedNewIndex()
        }
        
    }
    override init(frame:CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init (coder:NSCoder){
        super.init(coder:coder)!
        setupView()
    }
    func setupView(){
        layer.cornerRadius = frame.height / 2
        //layer.borderColor = UIColor.white.cgColor
        //layer.borderWidth = 2
        backgroundColor = UIColor.clear
        setupAllLabels()
        insertSubview(view, at: 0)
    }
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let loc = touch.location(in:self)
        var cal:Int?
        for(index,items) in labels.enumerated(){
            if items.frame.contains(loc){
                cal = index
            }
        }
        if cal != nil{
            selectedIndex = cal!
            sendActions(for: .valueChanged)
            print("selectedIndex:\(selectedIndex)")
        }
        return false
    }
    func selectedNewIndex(){
        let label = labels[selectedIndex]
        self.view.frame = label.frame
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var selectedFrame = self.bounds
        let newWidth = selectedFrame.width / CGFloat(items.count)
        selectedFrame.size.width = newWidth
        view.frame = selectedFrame
        //view.backgroundColor = UIColor.darkGray
        //UIColor.init(red: 230/255, green: 100/255, blue: 68/255, alpha: 1.0)
        view.layer.cornerRadius = view.frame.height / 2
        let labelHeight = self.bounds.height
        let labelWidth  = self.bounds.width / CGFloat(labels.count)
        for ind in 0...labels.count - 1 {
            
            let l = labels[ind]
            let xpos = CGFloat(ind) * labelWidth
            l.frame = CGRect(x: xpos, y: 0, width: labelWidth, height: labelHeight)
        }
    }
    
    
}
    
