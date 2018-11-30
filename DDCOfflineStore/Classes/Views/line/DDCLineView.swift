//
//  DDCLineView.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/25.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit

enum DDCLineStyle: Int {
    case none
    case dotted
    case solid
}

class DDCLineView: UIView {
    var style: DDCLineStyle {
        get {
            return .dotted
        }
    }
    //{
//        didSet{
//            self.layer.sublayers = nil
//            switch style {
//            case .dotted?:
//                self.layer.addSublayer(self.dotterLayer)
//            case .solid?:
//                self.layer.addSublayer(self.solidLayer)
//            case .none?:
//                break
//            default:
//                break
//            }
//        }
//    }
    
    var dotterLayer: CAShapeLayer = {
        var _dotterLayer = CAShapeLayer.init()
        _dotterLayer.fillColor = UIColor.clear.cgColor
        _dotterLayer.lineWidth = 1
        _dotterLayer.lineJoin = CAShapeLayerLineJoin.round
        _dotterLayer.lineDashPattern = [5,2]
        return _dotterLayer
    }()
    
    var solidLayer: CAShapeLayer = {
       var _solidLayer = CAShapeLayer.init()
        _solidLayer.fillColor = UIColor.clear.cgColor
        _solidLayer.lineWidth = 1
        _solidLayer.lineJoin = CAShapeLayerLineJoin.round
        return _solidLayer
    }()
    
    override var bounds: CGRect
    {
        didSet{
            super.bounds = bounds

            self.solidLayer.bounds = self.bounds
            self.solidLayer.position = CGPoint.init(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
            let path: CGMutablePath = CGMutablePath.init()
            path.move(to: CGPoint.init(x: 0, y: self.bounds.size.height / 4))
            path.addLine(to: CGPoint.init(x: self.bounds.size.width, y: self.bounds.size.height / 4))
            self.solidLayer.path = path
            
            self.dotterLayer.bounds = self.bounds
            self.dotterLayer.position = CGPoint.init(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
            self.dotterLayer.path = path
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawLine(style: DDCLineStyle, color: UIColor) {
        self.setStyle(style: style)

        self.solidLayer.strokeColor = color.cgColor
        self.dotterLayer.strokeColor = color.cgColor
    }
    
    func setStyle(style: DDCLineStyle) {
        self.layer.sublayers = nil
        switch style {
        case .dotted:
            self.layer.addSublayer(self.dotterLayer)
        case .solid:
            self.layer.addSublayer(self.solidLayer)
        case .none:
            break
        default:
            break
        }
    }
}
