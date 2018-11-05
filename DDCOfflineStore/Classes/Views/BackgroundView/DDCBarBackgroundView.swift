//
//  DDCBarBackgroundView.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/8.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCBarBackgroundView: UIView {
    
    public lazy var tableView : UITableView = {
        let tableView : UITableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        tableView.backgroundColor = UIColor.white
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.setBlackShadow()
        self.setRectCornerTop()
        self.addSubview(self.tableView)
        self.setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: private
extension DDCBarBackgroundView {
    //设置上部圆角
    func setRectCornerTop() {
        let width = self.bounds.size.width
        let height = self.bounds.size.height
        
        if(width==0||height==0) {return}
        
        let maskPath : UIBezierPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize.init(width: 20.0, height: 20.0))
        let maskLayer : CAShapeLayer = CAShapeLayer.init()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    //设置黑色阴影
    func setBlackShadow() {
        self.layer.masksToBounds = true
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSize.init(width: 20.0, height: 20.0)
        self.layer.shadowColor = UIColor.white.cgColor
    }
    
    func setupViewConstraints() {
        self.tableView.snp.makeConstraints({ (make) in
            make.top.left.right.equalTo(self)
            make.bottom.equalTo(self)
        })
    }
}
