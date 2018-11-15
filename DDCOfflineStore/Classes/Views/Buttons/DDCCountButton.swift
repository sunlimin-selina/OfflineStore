//
//  DDCCountButton.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/9.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class CountButton: UIButton {
    
    var countDown: UInt?
    var countDownTimer: Timer?
    var counting: Bool?
    var delegate: CountButtonDelegate?
    static let countTime: UInt = 60

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public
    func startCountDown() {
        self.countDownTimer?.invalidate()
        self.countDownTimer = nil
        self.countDown = CountButton.countTime
        self.isEnabled = false
        self.setTitleColor(DDCColor.mainColor.red, for: .normal)
        self.countDownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDownTime), userInfo: nil, repeats: true)
    }
    
    func stopCountDown() {
        self.counting = false
        self.countDownTimer?.invalidate()
        self.countDownTimer = nil
        self.isEnabled = true
        self.setTitle("重新发送", for: .normal)
    }
    
    // MARK: Private
    @objc func countDownTime() {
        self.counting = true
        self.countDown! = self.countDown! - 1
        let title = NSString(format: "已发送(%lds)", self.countDown!) as String
        self.setTitle(title, for: .normal)
        if (self.countDown == 0) {
            self.isEnabled = true
            self.counting = false
            self.countDownTimer?.invalidate()
            self.countDownTimer = nil
            self.setTitle("重新发送", for: .normal)
            
        self.delegate?.countButton(button: self, isFinished: true)

        }
    }
}

protocol CountButtonDelegate {
    func countButton(button: CountButton , isFinished: Bool)
}


