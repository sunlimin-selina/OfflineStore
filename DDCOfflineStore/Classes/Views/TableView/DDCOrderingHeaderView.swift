//
//  DDCOrderingHeaderView.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/22.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

typealias OrderingUpdateCallback = (String?)->Void

class DDCOrderingHeaderView: UITableViewHeaderFooterView {

    var delegate : DDCOrderingHeaderViewDelegate?
    
    lazy var titleLabel: UILabel = {
        var _titleLabel = UILabel()
        _titleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        _titleLabel.textColor = UIColor.black
        _titleLabel.text = "我创建的订单"
        return _titleLabel
    }()
    
    lazy var orderingButton: UIButton = {
        var _orderingButton = UIButton.init(type: .custom)
        _orderingButton.setTitleColor(UIColor.black, for: .normal)
        _orderingButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        _orderingButton.setTitle("筛选", for: .normal)
        _orderingButton.setImage(UIImage.init(named: "arrowIconDown"), for: .normal)
        _orderingButton.setImage(UIImage.init(named: "arrowIconUp"), for: .selected)
        _orderingButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        _orderingButton.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
        _orderingButton.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 10)
        return _orderingButton
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.backgroundView = UIView(frame: self.bounds)
        self.backgroundView!.backgroundColor = UIColor.white
        self.addSubview(self.titleLabel)
        self.addSubview(self.orderingButton)
        self.setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Event
    @objc func buttonPressed(_ sender:UIButton) {
        sender.isSelected = true
        
        weak var weakSelf = self
        self.delegate?.headerView(self, callback: { (orderingType) in
            sender.isSelected = false
            if let _orderingType = orderingType {
                weakSelf!.orderingButton.setTitle(_orderingType, for: .normal)
            }
        })
    }
    
    // MARK: Private
    private func setupViewConstraints() {
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(self).offset(30)
        }
        
        self.orderingButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.titleLabel)
            make.right.equalTo(self).offset(-20)
        }
    }
}

protocol DDCOrderingHeaderViewDelegate {
    func headerView(_ headerView: DDCOrderingHeaderView, callback : @escaping OrderingUpdateCallback)
}
