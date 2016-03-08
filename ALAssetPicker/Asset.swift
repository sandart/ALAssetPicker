//
//  Asset.swift
//  ALAssetPicker
//
//  Created by 沙畫 on 15/11/2.
//  Copyright © 2015年 xiaoquxia. All rights reserved.
//

import UIKit
import AssetsLibrary

class Asset: NSObject {
    /*
     *是否选择
     */
    var isSelected:Bool!
    var assetItem:ALAsset!
    init(item:ALAsset) {
        super.init()
        isSelected = false
        assetItem = item
    }

}
