//
//  DDCLoadingView.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/10.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCLoadingView : UIView{
    lazy var loadingImage1: UIImageView = {
        var _loadingImage1 = UIImageView.init()
        _loadingImage1.image = UIImage.init(named: "loadingIcon")
        _loadingImage1.backgroundColor = UIColor.clear
        _loadingImage1.layer.borderColor = UIColor.clear.cgColor
        _loadingImage1.layer.borderWidth = 1.0
        _loadingImage1.layer.cornerRadius = 36.0
        _loadingImage1.layer.masksToBounds = true
        return _loadingImage1
    }()
    
    lazy var loadingImage2: UIImageView = {
        var _loadingImage2 = UIImageView.init()
        _loadingImage2.image = UIImage.init(named: "loadingIcon2")
        _loadingImage2.backgroundColor = UIColor.clear
        _loadingImage2.contentMode = .center;
        _loadingImage2.backgroundColor = UIColor.init(white: 0, alpha: 0.6)
        return _loadingImage2
    }()
    
    lazy var contentView: UIView = {
        var _contentView = UIView.init()
        _contentView.isUserInteractionEnabled = false
        _contentView.backgroundColor = UIColor.init(white: 0, alpha: 0.6)
        _contentView.layer.borderColor = UIColor.clear.cgColor
        _contentView.layer.borderWidth = 1.0
        _contentView.layer.cornerRadius = 5.0
        _contentView.layer.masksToBounds = true
        return _contentView
    }()
    
    static let instance: DDCLoadingView = DDCLoadingView(frame: CGRect.zero)
    class func sharedLoading() -> DDCLoadingView {
        return instance
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.loadingImage1)
        self.contentView.addSubview(self.loadingImage2)

        self.contentView.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(self)
            make.width.equalTo(82.0)
            make.height.equalTo(107.0)
        }
        
        self.loadingImage1.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.contentView).offset(5.0)
            make.width.height.equalTo(72.0)
        }
        
        self.loadingImage2.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.contentView)
            make.top.equalTo(self.contentView).offset(80.0)
            make.width.equalTo(82.0)
            make.height.equalTo(25.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func runAnimation() {
        let rotationAnimation : CABasicAnimation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber.init(value: Double.pi * 2.0)
        rotationAnimation.duration = 1.0
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = 100000
        DDCLoadingView.sharedLoading().loadingImage1.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
}

