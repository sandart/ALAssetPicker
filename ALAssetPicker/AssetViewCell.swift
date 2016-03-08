//
//  AssetViewCell.swift
//  ALAssetPicker
//
//  Created by 沙畫 on 15/10/24.
//  Copyright © 2015年 xiaoquxia. All rights reserved.
//  缩略图

import UIKit

import AssetsLibrary

class AssetViewCell: UICollectionViewCell {
    

    
    
    @IBOutlet weak var assetImageView: UIImageView!
    
    var selectedAssets : NSMutableArray! //=  NSMutableArray()
    var index : Int!
    var checkOption = {(asset : Asset) -> Void in}
    var asset:Asset!{
        didSet{
            let currentAsset = asset.assetItem
            assetImageView.image = UIImage(CGImage: currentAsset.thumbnail().takeUnretainedValue())
            selectedButton.selected  = asset.isSelected
        }
    }
    
    
    
    @IBOutlet weak var selectedButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectedButton: UIButton!
    
    @IBAction func selectedButtonClick(sender: UIButton) {
        
        sender.selected = !sender.selected
        asset.isSelected = sender.selected

        checkOption(asset)
        
        self.selectedButton.layer.removeAllAnimations()
        let scaoleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaoleAnimation.duration = 0.25;
        scaoleAnimation.autoreverses = true;
        scaoleAnimation.values = [NSNumber(float: 1.0),NSNumber(float: 1.2),NSNumber(float: 1.0)]
        scaoleAnimation.fillMode = kCAFillModeForwards;
        self.selectedButton.layer.addAnimation(scaoleAnimation, forKey: "transform.scale")

    }
    
    class func cellWithCollectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> AssetViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(AssetViewCell.productCollectionIdentifier, forIndexPath: indexPath) as!  AssetViewCell
        return cell
    }
    
    class var productCollectionIdentifier:String! {
        get {
            return "AssetColletionCellIdentifier"
        }
    }
}
