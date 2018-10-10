//
//  DDCInputFieldView.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/9.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit

class DDCInputFieldView: DDCCircularTextFieldView {
    
    var firstTextFieldView : DDCCircularTextFieldWithExtraButtonView?
    var secondTextFieldView : DDCCircularTextFieldView?
    
    var bottomHidden : Bool?
    var delegate : InputFieldViewDelegate?
    
}

protocol InputFieldViewDelegate {
    
}
