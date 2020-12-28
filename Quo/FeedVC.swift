//
//  FriendsFeedVC.swift
//  Quo
//
//  Created by Kevin Hall on 12/7/16.
//  Copyright © 2016 Kevin Hall. All rights reserved.
//

import Foundation
import UIKit
import Spruce
import PageMenu

class FriendsFeedVC: UIViewController {

    var gridCollectionView: UICollectionView!
    var gridLayout: GridLayout!
    let fullImageView = UIImageView()
    var scrollImg: UIScrollView = UIScrollView()
    let photoDetailsView = UIView()
    let photoDetailUser = UILabel()
    let photoDetailDate = UILabel()
    let photoDetailLikeButton = UIButton()
    let photoDetailLikeCount = UILabel()
    let photoDetailDescription = UILabel()
    var selectedPhoto = Int()
    var blurEffectView = UIVisualEffectView()
    var rotated:Bool = false // whether the picture is rotated in the fullimageview

    //for changing the grid size
    let cview = UIView()
    var cviewb1 = UIButton()
    var cviewb2 = UIButton()
    var cviewb3 = UIButton()
    var cviewb4 = UIButton()
    var cviewb5 = UIButton()
    var cviewb6 = UIButton()
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gridCollectionView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width  , height: self.view.frame.size.height)
        scrollImg.frame = CGRect(x: 5, y: self.view.frame.origin.y - 60, width: self.view.frame.width - 10, height: self.view.frame.size.height - 25)
        fullImageView.frame = CGRect(x:0,y:0,width: scrollImg.frame.width,height: scrollImg.frame.height)
        photoDetailsView.frame = CGRect(x: 0, y: self.view.frame.height - 10 , width: self.view.frame.width, height: 75)
        photoDetailsView.backgroundColor = COLOR_BG
        photoDetailUser.frame = CGRect(x: 70, y: 0, width: 125, height: 25)
        photoDetailDate.frame = CGRect(x: 70, y: 25, width: 125, height: 20)
        photoDetailLikeButton.frame = CGRect(x: 10, y: 5, width: 50, height: 40)
        photoDetailDescription.frame = CGRect(x: 200, y: 0, width: self.view.frame.width / 2 - 25, height: 45)
        
        cview.frame = CGRect(x: 5, y: -70, width: view.frame.width - 10, height: 70)
        let base = cview.frame.width/6 - 13
        cviewb1.frame = CGRect(x: base, y: cview.frame.height/3, width: 30, height: 30)
        cviewb2.frame = CGRect(x: base * 2, y: cview.frame.height/3, width: 30, height: 30)
        cviewb3.frame = CGRect(x: base * 3, y: cview.frame.height/3, width: 30, height: 30)
        cviewb4.frame = CGRect(x: base * 4, y: cview.frame.height/3, width: 30, height: 30)
        cviewb5.frame = CGRect(x: base * 5, y: cview.frame.height/3, width: 30, height: 30)
        cviewb6.frame = CGRect(x: base * 6, y: cview.frame.height/3, width: 30, height: 30)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = COLOR_BG
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = UIColor.rgb(10, green: 204, blue: 161)
        //self.navigationController?.navigationBar.barTintColor = UIColor.rgb(10, green: 204, blue: 161)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let sortFunction = LinearSortFunction(direction: .bottomToTop, interObjectDelay: 0.05)
        gridCollectionView.spruce.prepare(with: [.fadeIn, .expand(.slightly)])
        let animation = SpringAnimation(duration: 0.3)
        DispatchQueue.main.async {
            self.gridCollectionView.spruce.animate([.fadeIn, .expand(.slightly)], animationType: animation, sortFunction: sortFunction)
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationButtons()
        
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationItem.title = "HOME"
        
        setupChangeGridButtons()
        
        let path = UIBezierPath(roundedRect:CGRect(x:0,y:self.view.bounds.minY+(self.navigationController?.navigationBar.bounds.height)!,width:self.view.bounds.width,height:self.view.bounds.height - (self.navigationController?.navigationBar.bounds.height)! - (self.tabBarController?.tabBar.bounds.height)!),byRoundingCorners:[.allCorners],cornerRadii: CGSize(width: 15 , height:  15))
        let maskLayer = CAShapeLayer()
        maskLayer.fillColor = COLOR_TEXT.cgColor
        maskLayer.path = path.cgPath
        self.view.layer.mask = maskLayer
        self.navigationController?.view.layer.mask = maskLayer
        
        gridLayout = GridLayout()
        gridCollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: gridLayout)
        gridCollectionView.backgroundColor = COLOR_BG
        gridCollectionView.showsVerticalScrollIndicator = true
        gridCollectionView.showsHorizontalScrollIndicator = false
        self.view.addSubview(gridCollectionView)
        
        gridCollectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CollectionHeaderView")
        
        let layout = gridCollectionView.collectionViewLayout as? UICollectionViewFlowLayout // casting is required because UICollectionViewLayout doesn't offer header pin. Its feature of UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = false
        layout?.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        
        
        gridCollectionView!.register(ImageCell.self, forCellWithReuseIdentifier: "cell")
        gridCollectionView.dataSource = self
        gridCollectionView.delegate = self
        
        cview.backgroundColor = COLOR_TEXT.withAlphaComponent(0.0)
        cview.alpha = 0
        cview.tag = 10
        
        
        self.cview.addSubview(cviewb1)
        self.cview.addSubview(cviewb2)
        self.cview.addSubview(cviewb3)
        self.cview.addSubview(cviewb4)
        self.cview.addSubview(cviewb5)
        self.cview.addSubview(cviewb6)
        self.view.addSubview(cview)
        
        fullImageView.contentMode = .scaleAspectFit
        fullImageView.backgroundColor = COLOR_BG
        fullImageView.alpha = 0
        fullImageView.layer.cornerRadius = 2
        fullImageView.clipsToBounds = true
        
        
        scrollImg.delegate = self
        scrollImg.alwaysBounceVertical = true
        scrollImg.alwaysBounceHorizontal = true
        scrollImg.showsVerticalScrollIndicator = false
        scrollImg.isUserInteractionEnabled = true
        scrollImg.minimumZoomScale = 1.0
        scrollImg.maximumZoomScale = 2.0
        scrollImg.alpha = 0
        scrollImg.backgroundColor = COLOR_BG
        
        photoDetailsView.backgroundColor = COLOR_BG
        photoDetailsView.alpha = 0
        photoDetailUser.alpha = 1
        photoDetailUser.font = UIFont(name: "Futura-MediumItalic", size: 20)
        photoDetailUser.text = "Hypebeast"
        photoDetailUser.textColor = COLOR_TEXT
        photoDetailUser.textAlignment = .left
        
        photoDetailDate.alpha = 1
        photoDetailDate.font = UIFont.systemFont(ofSize: 9)
        photoDetailDate.text = "September 30 2017"
        photoDetailDate.textColor = COLOR_TEXT_HALF_ALPHA
        photoDetailDate.textAlignment = .left
        
        
        photoDetailDescription.alpha = 1
        photoDetailDescription.font = UIFont.systemFont(ofSize: 10)
        photoDetailDescription.text = "This is a test description its only 50 characters. And at this point its 75."
        photoDetailDescription.textColor = COLOR_TEXT
        photoDetailDescription.textAlignment = .left
        photoDetailDescription.numberOfLines = 3
        
        
        let title = NSAttributedString.init(string: "Like", attributes: [NSAttributedStringKey.foregroundColor:COLOR_TEXT, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 9)])
        photoDetailLikeButton.alpha = 1
        photoDetailLikeButton.layer.cornerRadius = 2
        photoDetailLikeButton.setAttributedTitle(title, for: .normal)
        photoDetailLikeButton.layer.borderColor = COLOR_TEXT.cgColor
        photoDetailLikeButton.layer.borderWidth = 0.5
        photoDetailLikeButton.clipsToBounds = true
        
        
        
        photoDetailLikeCount.font = UIFont.systemFont(ofSize: 9)
        photoDetailLikeCount.text = "235"
        photoDetailLikeCount.textColor = COLOR_TEXT_HALF_ALPHA
        photoDetailLikeCount.textAlignment = .left
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.init(rawValue: 6)!)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //self.photoDetailsView.addSubview(blurEffectView)
        
        self.view.addSubview(scrollImg)
        self.scrollImg.addSubview(fullImageView)
        self.view.addSubview(photoDetailsView)
        self.photoDetailsView.addSubview(photoDetailUser)
        self.photoDetailsView.addSubview(photoDetailDate)
        self.photoDetailsView.addSubview(photoDetailLikeButton)
        self.photoDetailsView.addSubview(photoDetailLikeCount)
        self.photoDetailsView.addSubview(photoDetailDescription)

        let dismissWihtTap = UITapGestureRecognizer(target: self, action: #selector(hideFullImage))
        scrollImg.addGestureRecognizer(dismissWihtTap)
    }
    

    
    func setupChangeGridButtons() {
        cviewb1 = {
            let button = UIButton()
            button.setImage(UIImage(named: "grid1"), for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.addTarget(self, action: #selector(cviewButtonAction(sender:)), for: .touchUpInside)
            button.layer.cornerRadius = 1
            return button
        }()
        cviewb2 = {
            let button = UIButton()
            button.setImage(UIImage(named: "grid2"), for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.addTarget(self, action: #selector(cviewButtonAction(sender:)), for: .touchUpInside)
            button.layer.cornerRadius = 1
            return button
        }()
        cviewb3 = {
            let button = UIButton()
            button.setImage(UIImage(named: "grid3"), for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.addTarget(self, action: #selector(cviewButtonAction(sender:)), for: .touchUpInside)
            button.layer.cornerRadius = 1
            return button
        }()
        cviewb4 = {
            let button = UIButton()
            //button.imageView?.contentMode = .scaleAspectFit
            button.setImage(UIImage(named: "grid4"), for: .normal)
            //button.imageEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            button.addTarget(self, action: #selector(cviewButtonAction(sender:)), for: .touchUpInside)
            button.layer.cornerRadius = 1
            //button.backgroundColor = UIColor.yellow
            return button
        }()
        cviewb5 = {
            let button = UIButton()
            button.setImage(UIImage(named: "grid5"), for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.addTarget(self, action: #selector(cviewButtonAction(sender:)), for: .touchUpInside)
            button.layer.cornerRadius = 1
            return button
        }()
        cviewb6 = {
            let button = UIButton()
            button.setImage(UIImage(named: "grid6"), for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.addTarget(self, action: #selector(cviewButtonAction(sender:)), for: .touchUpInside)
            button.layer.cornerRadius = 1
            return button
        }()
    }
    
    @objc func cviewButtonAction(sender:UIButton) {
        if sender == cviewb1 {
            changeGrid(to: 1)
        } else if sender == cviewb2 {
            changeGrid(to: 2)
        } else if sender == cviewb3 {
            changeGrid(to: 3)
        } else if sender == cviewb4 {
            changeGrid(to: 4)
        } else if sender == cviewb5 {
            changeGrid(to: 5)
        } else if sender == cviewb6 {
            changeGrid(to: 6)
        }
        
        hideGridChange()
    }
    

    @objc func upload() {
        let vc = UploadVC()
        self.present(vc, animated: true) {
        }
    }
    

    func addNavigationButtons() {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "Group 2"), for: UIControlState.normal)
        
        if let image = button.imageView?.image {
            button.setImage(image.imageWithColor(color1: COLOR_TEXT.withAlphaComponent(0.3)).withRenderingMode(.alwaysOriginal), for: .normal)
        }
        //button.setAttributedTitle(NSAttributedString.init(string: "New Post", attributes: [NSForegroundColorAttributeName:COLOR_TEXT.withAlphaComponent(0.3), NSFontAttributeName: UIFont(name: "Futura-MediumItalic", size: 11)!]), for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
        button.addTarget(self, action:#selector(self.upload), for: UIControlEvents.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 10, height: 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        
        let gridButton = UIButton.init(type: .custom)
        gridButton.setImage(UIImage.init(named: "grid"), for: UIControlState.normal)
        if let image = gridButton.imageView?.image {
            gridButton.setImage(image.imageWithColor(color1: COLOR_TEXT.withAlphaComponent(0.3)).withRenderingMode(.alwaysOriginal), for: .normal)
        }
        //gridButton.setAttributedTitle(NSAttributedString.init(string: "Format", attributes: [NSForegroundColorAttributeName:COLOR_TEXT.withAlphaComponent(0.3), NSFontAttributeName: UIFont(name: "Futura-MediumItalic", size: 11)!]), for: .normal)
        gridButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
        gridButton.addTarget(self, action:#selector(self.showChangegrid), for: UIControlEvents.touchUpInside)
        gridButton.frame = CGRect.init(x: 0, y: 0, width: 10, height: 30)
        let barButton2 = UIBarButtonItem.init(customView: gridButton)
    
        
        self.navigationItem.leftBarButtonItem = barButton2
    }
    
    
    
    func changeGrid(to : Int) {

        
        
        UIView.animate(withDuration: 0.3, delay: 0,options: [], animations: {

            let sortFunction = LinearSortFunction(direction: .bottomToTop, interObjectDelay: 0.05)
            let animation = SpringAnimation(duration: 0.3)
            
            self.gridCollectionView.performBatchUpdates({ () -> Void in
                self.gridLayout.numberOfCellsOnRow = CGFloat(to)
                self.gridCollectionView.collectionViewLayout = self.gridLayout
                self.gridCollectionView.spruce.prepare(with: [.fadeIn, .expand(.slightly)])
                self.gridCollectionView.spruce.animate([.fadeIn, .expand(.slightly)], animationType: animation, sortFunction: sortFunction)
            }, completion: { (finished) -> Void in
                
            })
            
            
        }, completion: { _ in
            //self.gridCollectionView.reloadData()
        })
    }
    
    @objc func showChangegrid() {
        
        if scrollImg.alpha == 1 {

            var angle =  CGFloat(Double.pi/2)
            
            if rotated {
                angle = CGFloat(4 * (Double.pi/2))
                rotated = false
            } else {
                angle =  CGFloat(Double.pi/2)
                rotated = true
            }
            
            
            let tr = CGAffineTransform.identity.rotated(by: angle)
            
            UIView.animate(withDuration: 0.4, delay: 0, options: [], animations:{
                self.fullImageView.transform = tr
                self.scrollImg.frame = CGRect(x: 5, y: self.view.frame.origin.y - 60, width: self.view.frame.width - 10, height: self.view.frame.size.height - 25)
                self.fullImageView.frame = CGRect(x:0,y:0,width: self.scrollImg.frame.width,height: self.scrollImg.frame.height)
            }, completion: nil)
            
        } else {
            if cview.alpha == 0{
                showGridChange()
            } else {
                hideGridChange()
            }
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView?{
        return self.fullImageView
    }
    
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView == scrollImg {
            if scrollView.zoomScale > 1 {
                //photoDetailsView.isHidden = true
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("did end scrolling animation")
        if scrollView.zoomScale == 1.0 {
            //photoDetailsView.isHidden = false
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("did end decelerating")
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("did end zooming")

        if scrollView.zoomScale > 1{
            //scrollView.setZoomScale(1.0, animated: true)
            //photoDetailsView.isHidden = false
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == scrollImg {
            //photoDetailsView.isHidden = true
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == scrollImg {
            if scrollView.contentOffset.y < -50  /*|| scrollView.contentOffset.x < -50 ||  scrollView.contentOffset.x > 50*/ {
                hideFullImage()
                
            } else if scrollView.contentOffset.x < -10 && scrollView.zoomScale == 1{
                if let cell = gridCollectionView.cellForItem(at: IndexPath.init(row: selectedPhoto-1, section: 0)){
                    if let image = (cell as! ImageCell).imageView.image {
                        swipeFullImageRight(of: image)
                    } else {
                        print("no photo")
                    }
                    selectedPhoto = selectedPhoto - 1
                }
            } else if scrollView.contentOffset.x > 10 && scrollView.zoomScale == 1{
                if let cell = gridCollectionView.cellForItem(at: IndexPath.init(row: selectedPhoto+1, section: 0)){
                    
                    if let image = (cell as! ImageCell).imageView.image {
                        swipeFullImageLeft(of: image)
                    } else {
                        print("no photo")
                    }
                    selectedPhoto = selectedPhoto + 1
                }
            }
        }
    }
    
    
    
    func swipeFullImageLeft(of image:UIImage) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations:{
            self.fullImageView.frame = self.fullImageView.frame.offsetBy(dx:  -self.fullImageView.bounds.width, dy: 0)
            
        }, completion: { (success) -> Void in
            
            self.fullImageView.frame = self.fullImageView.frame.offsetBy(dx:  2*self.fullImageView.bounds.width, dy: 0)
            self.fullImageView.image = image
            
            // When download completes,control flow goes here.
            if success {
                UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations:{
                    self.fullImageView.frame = self.fullImageView.frame.offsetBy(dx:  -self.fullImageView.bounds.width, dy: 0)
                    
                    
                }, completion: nil)
            }
        })
    }
    
    func swipeFullImageRight(of image:UIImage) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations:{
            self.fullImageView.frame = self.fullImageView.frame.offsetBy(dx:  self.fullImageView.bounds.width, dy: 0)
            
        }, completion: { (success) -> Void in
            
            self.fullImageView.frame = self.fullImageView.frame.offsetBy(dx:  -2*self.fullImageView.bounds.width, dy: 0)
            self.fullImageView.image = image
            
            // When download completes,control flow goes here.
            if success {
                UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations:{
                    self.fullImageView.frame = self.fullImageView.frame.offsetBy(dx:  self.fullImageView.bounds.width, dy: 0)
                    
                    
                }, completion: nil)
            }
        })
    }

    
    
    func showFullImage(of image:UIImage) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.hidesBarsOnSwipe = false

        
        //scrollImg.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        let theAttributes:UICollectionViewLayoutAttributes! = gridCollectionView.layoutAttributesForItem(at: (gridCollectionView.indexPathsForSelectedItems?.first)!)
        let cellFrameInSuperview:CGRect!  = gridCollectionView.convert(theAttributes.frame, to: gridCollectionView.superview)
        
        
        //photoDetailsView.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations:{
            self.gridCollectionView.alpha = 0
            self.fullImageView.image = image
            self.fullImageView.alpha = 1
            self.scrollImg.alpha = 1
            //self.scrollImg.transform = CGAffineTransform(scaleX: 1, y: 1)
            
        }, completion: nil)
        
        self.photoDetailsView.alpha = 1
//        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations:{
//
//            //self.photoDetailsView.transform = CGAffineTransform(scaleX: 1, y: 1)
//        }, completion: nil)
        
        var frame = self.tabBarController?.tabBar.frame
        frame = frame?.offsetBy(dx: 0, dy: (self.tabBarController?.tabBar.frame.height)!)
        UIView.animate(withDuration: 0.2, animations: {
            self.tabBarController?.tabBar.frame = frame!
            self.scrollImg.frame = self.scrollImg.frame.offsetBy(dx: 0, dy: -30)
        })
        
        
        
        self.scrollImg.frame = CGRect(x: 0, y: 0, width: self.view.frame.width , height: self.view.frame.size.height - 20)
        self.fullImageView.frame = CGRect(x:0,y:0,width: scrollImg.frame.width,height: scrollImg.frame.height)
        
        
    }
    
    @objc func hideFullImage() {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.hidesBarsOnSwipe = true


        
        //animate hiding everything
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations:{[unowned self] in
            self.scrollImg.alpha = 0
            self.fullImageView.alpha = 0
            }, completion: { (success) -> Void in
                //cview?.removeFromSuperview()
                self.photoDetailsView.alpha = 0
                
                
            })
        
        //resets the scale so the next picture viewed isnt zoomed in
        scrollImg.zoomScale = 1
        
        //hide the tab bar on image close
        UIView.animate(withDuration: 0.2, animations: {
            self.tabBarController?.tabBar.frame = (self.tabBarController?.tabBar.frame.offsetBy(dx: 0, dy: -(self.tabBarController?.tabBar.frame.height)!))!
            self.scrollImg.frame = self.scrollImg.frame.offsetBy(dx: 0, dy: 30)
            self.gridCollectionView.alpha = 1
        })
        (self.parent as? DashBoardVC)?.showTabBar()
        
    }
    
    
    
    func showGridChange() {
        
        self.navigationController?.hidesBarsOnSwipe = false
        

        UIView.animate(withDuration: 0.3, delay: 0.1, options: [], animations:{[unowned self] in
            self.gridCollectionView.frame = self.gridCollectionView.frame.offsetBy(dx: 0, dy: 70)
            self.cview.frame = self.cview.frame.offsetBy(dx: 0, dy: 70)
            self.cview.alpha = 1
                    
        }, completion: nil)
        
        

    }
    
    func hideGridChange() {
        
        //let cview = view.viewWithTag(10)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.gridCollectionView.frame = self.gridCollectionView.frame.offsetBy(dx: 0, dy: -70)
            self.cview.frame = (self.cview.frame.offsetBy(dx: 0, dy: -70))
            self.cview.alpha = 0
        }, completion: { (success) -> Void in
            //cview?.removeFromSuperview()
            self.navigationController?.hidesBarsOnSwipe = true


        })
    }

    
}



extension FriendsFeedVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 70
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    

    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "CollectionHeaderView",
                                                                             for: indexPath) as! CollectionHeaderView

            
            
            headerView.layer.cornerRadius = 1
            headerView.clipsToBounds = true
            let imageView = UIImageView(image: UIImage(named: "Rectangle 3"))
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
            
            if indexPath.section == 0 {
                blurEffectView.removeFromSuperview()
                imageView.frame = CGRect(x: 0, y: 0, width: 375, height: 30)
                //headerView.addSubview(imageView)
                
                headerView.textLabel.text = "Today"
                headerView.textLabel.backgroundColor = COLOR_BG
                headerView.textLabel.layer.cornerRadius = 3
                headerView.textLabel.clipsToBounds = true
                headerView.addSubview(headerView.textLabel)
                headerView.backgroundColor = COLOR_BG
            } else {
                imageView.removeFromSuperview()
                vibrancyEffectView.frame = CGRect(x: 0, y: 0, width: 375, height: 40)
                blurEffectView.frame = CGRect(x: 0, y: 0, width: 375, height: 40)
                //headerView.addSubview(blurEffectView)
                
                headerView.addSubview(headerView.textLabel)
                headerView.textLabel.text = "October 5"
            }

            return headerView
            
        default:
            
            assert(false, "Unexpected element kind")
        }
    }
    
    

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if section == 0 {
            return CGSize(width: self.view.frame.width, height: 30)
        } else {
            return CGSize(width: self.view.frame.width, height: 40)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
        cell.imageView.image = UIImage.init(named: "\(indexPath.row % 16)")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ImageCell
        if let image = cell.imageView.image {
            self.showFullImage(of: image)
            selectedPhoto = indexPath.row
        } else {
            print("no photo")
        }
    }
}














