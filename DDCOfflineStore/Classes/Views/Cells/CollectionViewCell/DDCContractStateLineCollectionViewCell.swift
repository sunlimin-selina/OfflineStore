//
//  DDCContractStateLineCollectionViewCell.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/16.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCContractStateLineCollectionViewCell: UICollectionViewCell {
    var lineView: DDCLineView = DDCLineView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.lineView)
        self.setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewConstraints() {
        self.lineView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.contentView)
        })
    }
    
    func configureCell(style: DDCLineStyle) {
        self.lineView.drawLine(style: style, color: (style == DDCLineStyle.solid) ? DDCColor.mainColor.red: DDCColor.colorWithHex(RGB: 0x979797))
    }
    
    class func height() -> CGFloat {
        return 10.0
    }
    
}
