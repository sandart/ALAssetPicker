//
//  AssetOriginalListViewController.swift
//  ALAssetPicker
//
//  Created by 沙畫 on 15/10/25.
//  Copyright © 2015年 xiaoquxia. All rights reserved.
//  图片原图http://pan.baidu.com/share/init?shareid=2333002892&uk=910491296

import UIKit
import AssetsLibrary

let kAssetOriginalCellGapWidth:CGFloat = 10
typealias PreviewOperation =  (asset : Asset) -> Void
class AssetOriginalListViewController: UICollectionViewController{
    
    /// 预览操作
    var previewSelectedOperation:PreviewOperation?
    var imagesAssetOriginalList:NSMutableArray!
    var selectedAssets:NSMutableArray!  //已选图片集合
    var indexBySelected:Int = 0                 //已选图片的下标
    
    var topNavigationBar:UIView!
    var bottomToolBar:UIView!
    
    var originalButton:UIButton!
    var originaLabel:UILabel!
    var sendCountButton:UIButton!
    var navCheckButton:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
        setTopNavigationBar()
        setBottomToolBar()
        setTapGestureRecognizer()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if indexBySelected == 0 {
           scrollViewDidScroll(self.collectionView!)
        }
        else{
            let indexPath = NSIndexPath(forItem: 0, inSection: indexBySelected)
            self.collectionView?.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
        }
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    func setTapGestureRecognizer(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTapGestureRecognizer:")
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func handleTapGestureRecognizer(gestureRecognizer : UITapGestureRecognizer ){
        topNavigationBar.hidden = !topNavigationBar.hidden
        bottomToolBar.hidden = !bottomToolBar.hidden
    }
    

    
    func setUp(){
        self.navigationController?.navigationBarHidden = true
        var tempframe = self.collectionView!.frame
        tempframe.size.width = tempframe.size.width + 2 * kAssetOriginalCellGapWidth
        tempframe.origin.x = -kAssetOriginalCellGapWidth
        self.collectionView?.frame = tempframe
    
    }
    
    func setTopNavigationBar(){
        let navBar = UIView(frame: CGRectMake(0, 0, kMainScreenWidth, 64))
        navBar.backgroundColor = UIColor(red: 47/255, green: 53/255, blue: 53/255, alpha: 0.7)
        let backButton = UIButton(type: UIButtonType.Custom)
        backButton.setImage(UIImage(named: "FriendsSendsPicturesQuitBigIcon"), forState: UIControlState.Normal)
        backButton.adjustsImageWhenHighlighted = false
        backButton.frame = CGRectMake(8, 11, 42, 42)
        backButton.addTarget(self, action: "backButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        navBar.addSubview(backButton)
        
        let checkButton = UIButton(type: UIButtonType.Custom)
        checkButton.setImage(UIImage(named: "FriendsSendsPicturesSelectBigNIcon"), forState: UIControlState.Normal)
        checkButton.setImage(UIImage(named: "FriendsSendsPicturesSelectBigYIcon"), forState: UIControlState.Selected)
        checkButton.adjustsImageWhenHighlighted = false
        checkButton.frame = CGRectMake(kMainScreenWidth - 42 - 10, 11, 42, 42)
        checkButton.addTarget(self, action: "checkButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        navCheckButton = checkButton
        navBar.addSubview(checkButton)
        
        topNavigationBar = navBar
        self.view.addSubview(topNavigationBar)
    }
    
    func backButtonClick(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func checkButtonClick(checkButton:UIButton){
        
        checkButton.selected = !checkButton.selected

        let visibleCell = self.collectionView?.visibleCells().first as! AssetOriginalViewCell
        visibleCell.asset.isSelected = checkButton.selected
        
        if (previewSelectedOperation != nil) {
             previewSelectedOperation!(asset: visibleCell.asset)
        }
        
        if checkButton.selected == true {
            
            self.selectedAssets.addObject(visibleCell.asset)
            
            self.sendCountButton.setTitle("\(selectedAssets.count)", forState: UIControlState.Normal)
            self.sendCountButton.alpha = 1.0
            
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                
               checkButton.transform = CGAffineTransformScale(checkButton.transform, 0.5, 0.5);
                self.sendCountButton.transform = CGAffineTransformScale(self.sendCountButton.transform, 0.2, 0.2);
                
                }) { (finished) -> Void in
                    UIView.animateWithDuration(0.1) { () -> Void in
                          checkButton.transform = CGAffineTransformScale(checkButton.transform, 2, 2);
                        self.sendCountButton.transform = CGAffineTransformScale(self.sendCountButton.transform, 5, 5);
                    }
                }
            print( "选中图片个数\(self.selectedAssets.count)")
        }
        else{
            self.selectedAssets.removeObject(visibleCell.asset)

            if  selectedAssets.count == 0 {
                sendCountButton.setTitle("", forState: UIControlState.Normal)
                sendCountButton.alpha = 0
            }
            else{
                self.sendCountButton.setTitle("\(selectedAssets.count)", forState: UIControlState.Normal)
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.sendCountButton.transform = CGAffineTransformScale(self.sendCountButton.transform, 0.2, 0.2);
                    
                    }) { (finished) -> Void in
                        UIView.animateWithDuration(0.1) { () -> Void in
                            self.sendCountButton.transform = CGAffineTransformScale(self.sendCountButton.transform, 5, 5);
                        }
                }
            }
            print( "剩余选中个数\(self.selectedAssets.count)")
        }

    }
    
    func setBottomToolBar(){

        let toolBar = UIView(frame: CGRectMake(0, kMainScreenHeight - 44, kMainScreenWidth, 44))
        toolBar.backgroundColor = UIColor(red: 47/255, green: 53/255, blue: 53/255, alpha: 0.7)
        
        let bottomOriginalButton = UIButton(type: UIButtonType.Custom)
        bottomOriginalButton.addTarget(self, action: "originalButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        bottomOriginalButton.frame = CGRectMake(10,(toolBar.bounds.height - 30)/2, 100, 30)
        
        let originalButton = UIButton(type: UIButtonType.Custom)
        originalButton.setImage(UIImage(named: "FriendsSendsPicturesArtworkNIcon"), forState: UIControlState.Normal)
        originalButton.setImage(UIImage(named: "FriendsSendsPicturesArtworkIcon"), forState: UIControlState.Selected)
        originalButton.adjustsImageWhenHighlighted = false
        originalButton.frame = CGRectMake(0, (bottomOriginalButton.bounds.height - 21)/2, 20, 21)
        originalButton.userInteractionEnabled = false
        self.originalButton = originalButton
        
        let originaLabel = UILabel(frame: CGRectMake(originalButton.bounds.size.width + 5, (bottomOriginalButton.bounds.height - 21)/2, 80, 21))
        originaLabel.font = UIFont.boldSystemFontOfSize(11)
        originaLabel.textColor = UIColor.whiteColor()
        originaLabel.text = "原图"
        self.originaLabel = originaLabel
        
        bottomOriginalButton.addSubview(originalButton)
        bottomOriginalButton.addSubview(originaLabel)
        toolBar.addSubview(bottomOriginalButton)
        
        
        let bottomSendButton = UIButton(type: UIButtonType.Custom)
        bottomSendButton.addTarget(self, action: "sendButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        bottomSendButton.frame = CGRectMake(kMainScreenWidth - 62 - 10, 10, 62, 30)
        
        let sendCountButton = UIButton(type: UIButtonType.Custom)
        sendCountButton.setBackgroundImage(UIImage(named: "FriendsSendsPicturesNumberIcon"), forState: UIControlState.Normal)
        sendCountButton.setTitle("\(selectedAssets.count)", forState: UIControlState.Normal)
        sendCountButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        sendCountButton.adjustsImageWhenHighlighted = false
        sendCountButton.frame = CGRectMake(0, 1, 25, 26)
        sendCountButton.userInteractionEnabled = false
        if selectedAssets.count <= 0 {
           sendCountButton.alpha = 0
        }
        else{
           sendCountButton.alpha = 1
        }

        self.sendCountButton = sendCountButton
        
        let sendButton = UIButton(type: UIButtonType.Custom)
        sendButton.setTitle("发送", forState: UIControlState.Normal)
        sendButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        sendButton.setTitleColor(textGreenColor, forState: UIControlState.Normal)
        sendButton.frame = CGRectMake(27, 0, 30, 30)
        sendButton.userInteractionEnabled = false
        
        bottomSendButton.addSubview(sendCountButton)
        bottomSendButton.addSubview(sendButton)
        toolBar.addSubview(bottomSendButton)
        
        bottomToolBar = toolBar
        self.view.addSubview(bottomToolBar)

        
    }
    
    
    func originalButtonClick(send:UIButton){
        
        send.selected = !send.selected
        
        let visibleCell = self.collectionView?.visibleCells().first as! AssetOriginalViewCell
        let selectedStatus  = visibleCell.asset.isSelected

        if !selectedStatus && send.selected == true{
            //1、当前图片选中原图且图片未选中
            //计算图片的大小
            calculateImageCapital(visibleCell.asset)
            self.originalButton.selected = send.selected
            //刷新cell设置选择
            let index = self.imagesAssetOriginalList.indexOfObject(visibleCell.asset)
            let currentAsset = self.imagesAssetOriginalList.objectAtIndex(index) as! Asset
            currentAsset.isSelected = true
            checkButtonClick(navCheckButton)
            
        }
        else if !send.selected{
            //2、当前图片取消选中原图
            self.originalButton.selected = send.selected
            self.originaLabel.text = "原图"
        }
        else{
            calculateImageCapital(visibleCell.asset)
            self.originalButton.selected = send.selected
        }

    }
    
    func sendButtonClick(send:UIButton){
        print("发送图片")
        
    }
    
    //MARK: - 子线程计算图片的大小
    func calculateImageCapital(item:Asset){
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let representation: ALAssetRepresentation  = item.assetItem.defaultRepresentation();
            var fileCapital = ""
            if representation.size()/(1024*1024) > 0 {
                fileCapital = String(format: "%.1fMB", CGFloat(representation.size())/(1024*1024))
            }
            else{
                fileCapital = "\(representation.size()/1024)KB"
            }
            self.originaLabel.text = "原图(\(fileCapital))"
        }
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return imagesAssetOriginalList.count
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = AssetOriginalViewCell.cellWithCollectionView(collectionView, cellForItemAtIndexPath: indexPath)
        if imagesAssetOriginalList.count > 0 {
            cell.asset = imagesAssetOriginalList[indexPath.section] as! Asset
        }
        return cell
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let currentPage = (NSInteger)((scrollView.contentOffset.x / scrollView.frame.size.width) + 0.5)
        let asset = imagesAssetOriginalList[currentPage] as! Asset
            navCheckButton.selected = asset.isSelected
        //已开启原图模式
        if originalButton.selected {
            calculateImageCapital(asset)
        }
    }
    
    //MARK - 特殊处理导航栏check button
//    func reloadData(){
//        self.collectionView?.reloadData()
//        self.collectionView?.layoutIfNeeded()
//        print("  ------ \(self.collectionView?.bounds.size.width) ------- ")
//        self.collectionView!.contentOffset = CGPointMake( CGFloat(self.indexBySelected) * (self.collectionView?.bounds.size.width)!, self.collectionView!.contentOffset.y);
//    }
    
    
    
//    //MARK: - 处理特殊拖拽BUG
//    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//        if  let index = self.collectionView?.indexPathsForVisibleItems().first  {
//            collectionView(self.collectionView!, cellForItemAtIndexPath: index)
//        }
//    }
    
//    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if !decelerate {
//            scrollViewDidEndDecelerating(scrollView)
//        }
//    }


//    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        
//      return UICollectionReusableView(frame: CGRectMake(0, 0, 20, UIScreen.mainScreen().bounds.height - 20))
//    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
//        //        return LineSpacingWH
//        return 10
//    }
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
//        return 10
//    }
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        
//    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        
        return CGSizeMake(UIScreen.mainScreen().bounds.width + 2 * kAssetOriginalCellGapWidth, UIScreen.mainScreen().bounds.height);
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
