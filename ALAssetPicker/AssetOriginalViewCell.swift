//
//  AssetOriginalViewCell.swift
//  ALAssetPicker
//
//  Created by 沙畫 on 15/10/25.
//  Copyright © 2015年 xiaoquxia. All rights reserved.
//  查看大图

import UIKit
import AssetsLibrary

class AssetOriginalViewCell: UICollectionViewCell,UIScrollViewDelegate {
    
    var lastScaleFactor : CGFloat = 1.0
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.delegate = self
            scrollView.frame = UIScreen.mainScreen().bounds;
            assetOriginalImageView = UIImageView(frame: CGRectZero)
            assetOriginalImageView.contentMode = UIViewContentMode.Center;
            scrollView.addSubview(assetOriginalImageView)
        }
    }
    
    var displayImage : UIImage {
        set{
            scrollView.zoomScale = 1.0
            scrollView.maximumZoomScale = 1;
            scrollView.minimumZoomScale = 1;
            scrollView.contentSize = CGSizeMake(0, 0);
            
            assetOriginalImageView.image = newValue
            assetOriginalImageView.frame =  CGRect(origin: CGPointZero, size: newValue.size)
            scrollView.contentSize = newValue.size

            setMaxMinZoomScalesForCurrentBounds()
        }
        get{
            return assetOriginalImageView.image!
        }
    }
    
    var assetOriginalImageView: UIImageView!
    
    func setMaxMinZoomScalesForCurrentBounds(){

        // Reset
        scrollView.maximumZoomScale = 1;
        scrollView.minimumZoomScale = 1;
        scrollView.zoomScale = 1;
        
        // Bail if no image
        if (assetOriginalImageView.image == nil) {return};
        
        // Reset position
        assetOriginalImageView.frame = CGRectMake(0, 0, assetOriginalImageView.frame.size.width, assetOriginalImageView.frame.size.height);
        
        // Sizes
        let  boundsSize = scrollView.bounds.size;
        let imageSize = assetOriginalImageView.image!.size;
        
        // Calculate Min
        let xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
        let yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
        var minScale = min(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
        
        // Calculate Max
        let maxScale = 2 as CGFloat;

        // Image is smaller than screen so no zooming!
        if (xScale >= 1 && yScale >= 1) {
            minScale = min(xScale, yScale);
        }
        
        if (minScale >= 2) {
            minScale = 1;
        }

        // Set min/max zoom
        scrollView.maximumZoomScale = maxScale;
        scrollView.minimumZoomScale = minScale;
        
        // Initial zoom
        scrollView.zoomScale = minScale;
        
        // If we're zooming to fill then centralise
        if (scrollView.zoomScale != minScale) {
            // Centralise
            scrollView.contentOffset = CGPointMake((imageSize.width * scrollView.zoomScale - boundsSize.width) / 2.0,
                (imageSize.height * scrollView.zoomScale - boundsSize.height) / 2.0);
            // Disable scrolling initially until the first pinch to fix issues with swiping on an initally zoomed in photo
            scrollView.scrollEnabled = false;
        }
        
        // Layout
        self.setNeedsLayout()

    }
    
    override func layoutSubviews() {

        // Super
        super.layoutSubviews()

        // Center the image as it becomes smaller than the size of the screen
        let boundsSize = scrollView.bounds.size;
        var adjustmentFrame = assetOriginalImageView.frame;
        
        // Horizontally
        if (adjustmentFrame.size.width < boundsSize.width) {
            /**
            *  floorf 取下限值
            */
            adjustmentFrame.origin.x = CGFloat(floorf( Float((boundsSize.width - adjustmentFrame.size.width) / CGFloat(2.0))))
        } else {
            adjustmentFrame.origin.x = 0;
        }
        
        // Vertically
        if (adjustmentFrame.size.height < boundsSize.height) {
            adjustmentFrame.origin.y =  CGFloat(floorf( Float((boundsSize.height - adjustmentFrame.size.height) / CGFloat(2.0))))
        } else {
            adjustmentFrame.origin.y = 0;
        }
        
        // Center
        if (!CGRectEqualToRect(assetOriginalImageView.frame, adjustmentFrame)){
            assetOriginalImageView.frame = adjustmentFrame;
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return assetOriginalImageView
    }
    func scrollViewDidZoom(scrollView: UIScrollView) {
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }

    func setPinchGestureRecognizer(){
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: "handlePinchGestureRecognizer:")
        assetOriginalImageView.addGestureRecognizer(pinchGestureRecognizer)
    }
    
    func handlePinchGestureRecognizer(pinchRecognizer : UIPinchGestureRecognizer ){

        let factor = pinchRecognizer.scale

        if  factor > 1.0  {
            assetOriginalImageView.transform=CGAffineTransformMakeScale(lastScaleFactor+(factor-1), (lastScaleFactor+(factor-1)));
        }
        else{
            assetOriginalImageView.transform=CGAffineTransformMakeScale(lastScaleFactor*factor, lastScaleFactor*factor);
        }
        
        //状态是否结束，如果结束保存数据
        if(pinchRecognizer.state == UIGestureRecognizerState.Ended){
            if(factor>1){
                
              lastScaleFactor =  lastScaleFactor+(factor-1) > 2.0 ?  2.0  : lastScaleFactor+(factor-1)
                
                UIView.animateWithDuration(0.15, animations: { () -> Void in
                    self.assetOriginalImageView.transform=CGAffineTransformMakeScale(self.lastScaleFactor, self.lastScaleFactor);
                })
                
            }else{
                UIView.animateWithDuration(0.15, animations: { () -> Void in
                    self.assetOriginalImageView.transform = CGAffineTransformIdentity
                    self.lastScaleFactor = 1.0
                })
            }
        }
        scrollView.contentSize = assetOriginalImageView.frame.size
    }
    
    var asset:Asset!{
        didSet{
            let currentAsset = asset.assetItem
            let representation: ALAssetRepresentation  = currentAsset.defaultRepresentation();
            displayImage =  UIImage(CGImage: representation.fullScreenImage().takeUnretainedValue())
        }
    }
    
        class func cellWithCollectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> AssetOriginalViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(AssetOriginalViewCell.productCollectionIdentifier, forIndexPath: indexPath) as!  AssetOriginalViewCell
        return cell
    }
    
    class var productCollectionIdentifier:String! {
        get {
            return "AssetOriginalViewCellIdentifier"
        }
    }
}
