//
//  DDCCheckBox.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/13.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit

class DDCCheckBox: DDCRadioWithImageView {
    var handler: ((_ sender: UIButton)->Void)?
    lazy var textField: DDCCircularTextFieldView = {
        let _textField = DDCCircularTextFieldView()
        return _textField
    }()

    convenience init(frame: CGRect, handler : ((_ sender: UIButton)->Void)?) {
        self.init(frame: frame)
        self.handler = handler
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.button.setImage(UIImage.init(named: "btn_unselected"), for: .normal)
        self.button.setImage(UIImage.init(named: "btn_selected"), for: .selected)
        self.button.isUserInteractionEnabled = true
        self.button.addTarget(self, action: #selector(clickAction(sender:)), for: .touchUpInside)
        self.isUserInteractionEnabled = true
        self.addSubview(self.textField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHandler(handler : ((_ sender: UIButton)->Void)?) {
        self.handler = handler
    }
    
    @objc func clickAction(sender: UIButton) {
        self.handler!(self.button)
    }
    
}
