//
//  DDCContractListViewController.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/9/29.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit

class DDCViewController: UIViewController {
    var contractListView : DDCContractListView? 
    
    private var user : DDCUserModel?
    private var contractArray : Array<DDCContractDetailsModel>?
    private var blankView : DDCButtonView?
//    private var orderingUpdate : OrderingUpdateCallback?
    private var page : UInt?
    private var status : DDCContractStatus?

    override func viewWillAppear(_ animated: Bool) {
        //        self.networkViewRect = self.view.bounds;
        self.page = 0;
        //        [self.view.collectionHolderView.collectionView setFooterHidden:NO];
        //        [self reloadPage];
        //        self.navigationController.navigationBarHidden = YES;
        //
        //        __weak typeof(self) weakSelf = self;
        //        [DDCVersionCheckAPIManager checkCurrentVersionSuccessHandler:^(BOOL isCurrentVersion) {
        //            if (!isCurrentVersion)
        //            {
        //            [weakSelf alertCycle];
        //            }
        //            } failHandler:^(NSError *err) {
        //            //
        //            }];
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    
}

