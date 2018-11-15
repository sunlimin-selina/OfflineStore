//
//  DDCButton.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/16.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit

class DDCButton: UIButton {
    var backgroundColors: Dictionary<String, UIColor> = Dictionary()
    var fonts: Dictionary<String, UIFont> = Dictionary()
    
    override public var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        
        set {
            let highlightedKey: String = self.key(for: .highlighted)
            let highlightedColor: UIColor? = self.backgroundColors[highlightedKey]
            let highlightedFont: UIFont? = self.fonts[highlightedKey]
            
            if isHighlighted {
                //字体修改
                if let font = highlightedFont {
                    super.titleLabel?.font = font
                } else {
                    if self.isSelected{
                        let selectedKey: String = self.key(for: .selected)
                        let selectedFont: UIFont = self.fonts[selectedKey]!
                        super.titleLabel?.font = selectedFont
                    } else {
                        let normalKey: String = self.key(for: .selected)
                        super.titleLabel?.font = self.fonts[normalKey]
                    }
                }
                //背景色修改
                if let color = highlightedColor {
                    super.backgroundColor = color
                } else {
                    // 由于系统在调用setSelected后，会再触发一次setHighlighted，故做如下处理，否则，背景色会被最后一次的覆盖掉。
                    if self.isSelected{
                        let selectedKey: String = self.key(for: .selected)
                        let selectedColor: UIColor = self.backgroundColors[selectedKey]!
                        super.backgroundColor = selectedColor
                    } else {
                        let normalKey: String = self.key(for: .selected)
                        super.backgroundColor = self.backgroundColors[normalKey]
                    }
                }
            }
        }
    }
    
    override public var isSelected: Bool {
        get {
            return super.isSelected
        }
        
        set {
            let selectedKey: String = self.key(for: .selected)
            let selectedColor: UIColor? = self.backgroundColors[selectedKey]!
            let selectedFont: UIFont? = self.fonts[selectedKey]!

            if isSelected {
                //字体修改
                if let font = selectedFont {
                    super.titleLabel?.font = font
                } else {
                    let normalKey: String = self.key(for: .selected)
                    super.titleLabel?.font = self.fonts[normalKey]
                }
                //背景色修改
                if let color = selectedColor {
                    super.backgroundColor = color
                } else {
                    let normalKey: String = self.key(for: .selected)
                    super.backgroundColor = self.backgroundColors[normalKey]
                }
            }
        }
        
    }
    
    func setBackgroundColor(_ color: UIColor?, for state: UIControl.State) {
        if state == .normal {
            super.backgroundColor = color
        }
        backgroundColors[self.key(for: state)] = color
    }
    
    func backgroundColor(for state: UIControl.State) -> UIColor? {
        return self.backgroundColors[self.key(for: state)]
    }
    
    func setFont(_ font: UIFont?, for state: UIControl.State) {
        if state == .normal {
            super.titleLabel?.font = font
        }
        fonts[self.key(for: state)] = font
    }
    
    func font(for state: UIControl.State) -> UIFont? {
        return self.fonts[self.key(for: state)]
    }
    
    func key(for state: UIControl.State) -> String {
        return "state_\(state)"
    }
}
