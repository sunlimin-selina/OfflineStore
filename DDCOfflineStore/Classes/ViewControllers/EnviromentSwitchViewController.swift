//
//  EnviromentSwitchViewController.swift
//  DDCOfflineStore
//
//  Created by moons on 2018/10/16.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit

class EnviromentSwitchViewController: UIViewController {
    
    private var hostString:String {
        set {
            self.hostLabel.text = "当前环境： " + newValue
        }
        get {
            return DDC_Current_Url
        }
    }
    
    private let hostLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkText
        return label
    }()
    
    private let segment: UISegmentedControl = {
        let items = ["测试环境", "开发环境", "Staging环境", "线上环境"]
        let seg = UISegmentedControl(items: items)
        seg.selectedSegmentIndex = DDCAPIManager.shared().currentNetWork.rawValue
        return seg
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "环境切换"
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.segment)
        self.segment.addTarget(self, action: #selector(switchAction), for: .valueChanged)
        
        self.view.addSubview(self.hostLabel)
        self.hostString = DDC_Current_Url
        
        self.addSegConstraints()
        self.addHostConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func addSegConstraints() {
        self.segment.translatesAutoresizingMaskIntoConstraints = false
        let left = NSLayoutConstraint(item: self.segment, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 60)
        let right = NSLayoutConstraint(item: self.segment, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: -60)
        let top = NSLayoutConstraint(item: self.segment, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 200)
        let height = NSLayoutConstraint(item: self.segment, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44)
        self.view.addConstraints([top, left, right, height])
    }
    
    func addHostConstraints() {
        self.hostLabel.translatesAutoresizingMaskIntoConstraints = false
        let left = NSLayoutConstraint(item: self.hostLabel, attribute: .left, relatedBy: .equal, toItem: self.segment, attribute: .left, multiplier: 1.0, constant: 0.0)
        let right = NSLayoutConstraint(item: self.hostLabel, attribute: .right, relatedBy: .equal, toItem: self.segment, attribute: .right, multiplier: 1.0, constant: 0.0)
        let top = NSLayoutConstraint(item: self.hostLabel, attribute: .top, relatedBy: .equal, toItem: self.segment, attribute: .bottom, multiplier: 1.0, constant: 80)
        let height = NSLayoutConstraint(item: self.hostLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44)
        self.view.addConstraints([top, left, height, right])
        
    }
    
    @objc func switchAction() {
        //print(String(self.segment.selectedSegmentIndex))
        let env = DDCAPIManager.NetworkEnvironment(rawValue: self.segment.selectedSegmentIndex)!
        DDCAPIManager.shared().switchEnv(env: env)
        self.hostString = DDC_Current_Url
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "EnvChange"), object: nil)
    }
    
}
