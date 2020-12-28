//
//  GroupFeedVC.swift
//  Quo
//
//  Created by Kevin Hall on 12/7/16.
//  Copyright © 2016 KAACK. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SwiftKeychainWrapper
import Spruce

class ProfileVC: UIViewController {
    
    var gridCollectionView: UICollectionView!
    var gridLayout: ProfileGrid!
    let fullImageView = UIImageView()
    var scrollImg: UIScrollView = UIScrollView()
    
    
    var imagePath = ""
    
    let profileDetailsView = UIView()
    let upUsername = UILabel()
    let upImageView = UIImageView()
    var upImage = UIImage()
    let upPostsCount = UILabel()
    let upPosts = UILabel()
    let upFollowersCount = UILabel()
    let upFollowers = UILabel()
    let upSocultCount = UILabel()
    let upSocult = UILabel()
    let upCloutCount = UILabel()
    let upClout = UILabel()
    
    let photoDetailsView = UIView()
    let photoDetailUser = UILabel()
    let photoDetailDate = UILabel()
    let photoDetailLikeButton = UIButton()
    let photoDetailLikeCount = UILabel()
    let photoDetailDescription = UILabel()
    
    var selectedPhoto = Int()
    
    let image = UIImageView()
    let img = UIImage(named:"pp")
    
    override func viewDidAppear(_ animated: Bool) {
        let sortFunction = DefaultSortFunction(interObjectDelay: 0.01)
        
        
        self.gridCollectionView.spruce.prepare(with: [.fadeIn, .expand(.slightly)])
        
        let animation = SpringAnimation(duration: 0.3)
        DispatchQueue.main.async {
            self.gridCollectionView.spruce.animate([.fadeIn, .expand(.slightly)], animationType: animation, sortFunction: sortFunction)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = COLOR_BG
        
        setProfileDetails()
        
        let path = UIBezierPath(roundedRect:self.view.bounds,byRoundingCorners:[.topLeft,.topRight],cornerRadii: CGSize(width: 10 , height:  10))

        
        let maskLayer = CAShapeLayer()
        maskLayer.fillColor = UIColor.black.cgColor
        
        maskLayer.path = path.cgPath
        self.view.layer.mask = maskLayer
        self.navigationController?.view.layer.mask = maskLayer
        
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "sign out"), for: UIControlState.normal)
        if let image = button.imageView?.image {
            button.setImage(image.imageWithColor(color1: COLOR_TEXT).withRenderingMode(.alwaysOriginal), for: .normal)
        }
        button.addTarget(self, action:#selector(signOutTapped), for: UIControlEvents.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        
        let gridButton = UIButton.init(type: .custom)
        gridButton.setImage(UIImage.init(named: "grid"), for: UIControlState.normal)
        if let image = gridButton.imageView?.image {
            gridButton.setImage(image.imageWithColor(color1: COLOR_TEXT).withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        gridButton.addTarget(self, action:#selector(self.changegrid), for: UIControlEvents.touchUpInside)
        gridButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
        let barButton2 = UIBarButtonItem.init(customView: gridButton)
        self.navigationItem.leftBarButtonItem = barButton2
        
        
        
        
        gridLayout = ProfileGrid()
        gridCollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: gridLayout)
        gridCollectionView.backgroundColor = COLOR_BG
        gridCollectionView.showsVerticalScrollIndicator = false
        gridCollectionView.showsHorizontalScrollIndicator = false
        self.view.addSubview(gridCollectionView)
        
        gridCollectionView!.register(ImageCell.self, forCellWithReuseIdentifier: "cell")
        gridCollectionView.dataSource = self
        gridCollectionView.delegate = self
        
       
        

        
        self.view.addSubview(profileDetailsView)
        //gridCollectionView.addSubview(profileDetailsView)
        gridCollectionView.contentInset.top = 175

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
        photoDetailDate.font = UIFont(name: "Futura-MediumItalic", size: 9)
        photoDetailDate.text = "4 Hours ago"
        photoDetailDate.textColor = COLOR_TEXT_HALF_ALPHA
        photoDetailDate.textAlignment = .left

        photoDetailLikeButton.alpha = 1
        photoDetailLikeButton.backgroundColor = COLOR_BG
        photoDetailLikeButton.layer.cornerRadius = 2
        photoDetailLikeButton.layer.borderColor = COLOR_TEXT.cgColor
        photoDetailLikeButton.layer.borderWidth = 0.5
        photoDetailLikeButton.clipsToBounds = true
        photoDetailLikeCount.font = UIFont(name: "Futura-MediumItalic", size: 9)
        photoDetailLikeCount.text = "235"
        photoDetailLikeCount.textColor = COLOR_TEXT_HALF_ALPHA
        photoDetailLikeCount.textAlignment = .left

        let sortFunction = CorneredSortFunction(corner: .topLeft, interObjectDelay: 0.55)
        
        self.gridCollectionView.spruce.prepare(with: [.fadeIn, .expand(.slightly)])
        
        self.gridCollectionView.spruce.animate([.fadeIn, .expand(.slightly)], sortFunction: sortFunction)
        
        self.view.addSubview(scrollImg)
        self.scrollImg.addSubview(fullImageView)
        self.view.addSubview(photoDetailsView)
        self.photoDetailsView.addSubview(photoDetailUser)
        self.photoDetailsView.addSubview(photoDetailDate)
        self.photoDetailsView.addSubview(photoDetailLikeButton)
        self.photoDetailsView.addSubview(photoDetailLikeCount)

        let dismissWihtTap = UITapGestureRecognizer(target: self, action: #selector(hideFullImage))
        scrollImg.addGestureRecognizer(dismissWihtTap)
        
      
    }
    
    @objc func signOutTapped(_ sender: AnyObject) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        //let keychainResult = KeychainWrapper.removeAllKeys()
        //let keychainResult = KeychainWrapper.defaultKeychainWrapper.remove(key: KEY_UID)
        print("KEV: ID removed from keychain \(keychainResult)")
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
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
            scrollView.setZoomScale(1.0, animated: true)
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
                        scrollView.setContentOffset(CGPoint.init(x: 900, y: 0), animated: false)
                        self.hideFullImage()
                        self.showFullImage(of: image)
                    } else {
                        print("no photo")
                    }
                    selectedPhoto = selectedPhoto - 1
                }
            } else if scrollView.contentOffset.x > 10 && scrollView.zoomScale == 1{
                if let cell = gridCollectionView.cellForItem(at: IndexPath.init(row: selectedPhoto+1, section: 0)){
                    
                    if let image = (cell as! ImageCell).imageView.image {
                        scrollView.setContentOffset(CGPoint.init(x: -900, y: 0), animated: false)
                        self.hideFullImage()
                        self.showFullImage(of: image)
                    } else {
                        print("no photo")
                    }
                    selectedPhoto = selectedPhoto + 1
                }
            }
        }
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        image.frame = CGRect(x: 78, y: 35, width: 220, height: 118)
        gridCollectionView.frame = CGRect(x: 5, y: 0, width: self.view.frame.width - 10, height: self.view.frame.size.height)
        scrollImg.frame = CGRect(x: 5, y: self.view.frame.origin.y - 60, width: self.view.frame.width - 10, height: self.view.frame.size.height - 25)
        fullImageView.frame = CGRect(x:0,y:0,width: scrollImg.frame.width,height: scrollImg.frame.height)
        photoDetailsView.frame = CGRect(x: 0, y: self.view.frame.height - 15, width: self.view.frame.width, height: 50)
        photoDetailUser.frame = CGRect(x: 20, y: 15, width: photoDetailsView.frame.width, height: 20)
        photoDetailDate.frame = CGRect(x: 20, y: 30, width: self.view.frame.width, height: 20)
        photoDetailLikeButton.frame = CGRect(x: self.view.frame.width - 50, y: 20, width: 25, height: 25)
        photoDetailLikeCount.frame = CGRect(x: self.view.frame.width - 80, y: 25, width: 25, height: 10)
        
        
        //profileDetailsView.frame = CGRect(x: self.view.frame.width/2 - 150, y: 35, width: 300, height: 145)
        profileDetailsView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 170)
        upUsername.frame = CGRect(x: profileDetailsView.frame.width / 2 + 20, y: profileDetailsView.frame.height / 2 - 55, width: 70, height: 25)
        upImageView.frame = CGRect(x: profileDetailsView.frame.width / 2 - 70, y: profileDetailsView.frame.height / 2 - 70, width: 60, height: 60)
        
        upPostsCount.frame = CGRect(x: profileDetailsView.frame.width / 2 - 140, y: profileDetailsView.frame.height / 2 + 30, width: 60, height: 10)
        upPosts.frame = CGRect(x: profileDetailsView.frame.width / 2 - 140, y: profileDetailsView.frame.height / 2 + 50, width: 60, height: 10)
        upFollowersCount.frame = CGRect(x: profileDetailsView.frame.width / 2 - 60, y: profileDetailsView.frame.height / 2 + 30, width: 60, height: 10)
        upFollowers.frame = CGRect(x: profileDetailsView.frame.width / 2 - 60, y: profileDetailsView.frame.height / 2 + 50, width: 60, height: 10)
        upSocultCount.frame = CGRect(x: profileDetailsView.frame.width / 2 + 20, y: profileDetailsView.frame.height / 2 + 30, width: 60, height: 10)
        upSocult.frame = CGRect(x: profileDetailsView.frame.width / 2 + 20, y: profileDetailsView.frame.height / 2 + 50, width: 60, height: 10)
        upCloutCount.frame = CGRect(x: profileDetailsView.frame.width / 2 + 100, y: profileDetailsView.frame.height / 2 + 30, width: 60, height: 10)
        upClout.frame = CGRect(x: profileDetailsView.frame.width / 2 + 100, y: profileDetailsView.frame.height / 2 + 50, width: 60, height: 10)

    }
    
    func setProfileDetails() {
        
        profileDetailsView.backgroundColor = UIColor.clear
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.prominent)
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = profileDetailsView.frame
        
        blurEffectView.frame = profileDetailsView.frame
        blurEffectView.contentView.addSubview(vibrancyEffectView)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        self.profileDetailsView.addSubview(blurEffectView)
        
        
        let uid = Auth.auth().currentUser?.uid
        
        DataService.ds.REF_USERS.child(uid!).observeSingleEvent(of: .value, with:  { (snapshot) in
            if !snapshot.exists() { return }
            
            print(snapshot)
            
            if let userName = (snapshot.value as? [String : String])?["username"]  {
                print(userName)
                self.upUsername.text = userName
            }
            if let email = (snapshot.value as? [String : String])?["email"] {
                print(email)
            }
            
            if let imgpath = (snapshot.value as? [String : String])?["urlToImage"] {
                self.imagePath = imgpath
                 self.upImageView.downloadImage(from: self.imagePath)
            }
            
            // can also use
            // snapshot.childSnapshotForPath("full_name").value as! String
        })

        upUsername.textColor = COLOR_TEXT
        upUsername.font = UIFont(name: "Futura-MediumItalic", size: 25)
        upUsername.textAlignment = .left
        upUsername.adjustsFontSizeToFitWidth = true
        
        //upImage = UIImage(named: "13")!
        upImageView.contentMode = .scaleAspectFill
        upImageView.clipsToBounds = true
        upImageView.layer.cornerRadius = 3
        
        upPostsCount.textColor = COLOR_TEXT
        upPostsCount.font = UIFont(name: "Futura-Medium", size: 12)
        upPostsCount.text = "110"
        upPostsCount.textAlignment = .center
        
        upPosts.textColor = COLOR_TEXT_HALF_ALPHA
        upPosts.font = UIFont(name: "Futura-Medium", size: 12)
        upPosts.text = "Posts"
        upPosts.textAlignment = .center
        
        upFollowersCount.textColor = COLOR_TEXT
        upFollowersCount.font = UIFont(name: "Futura-Medium", size: 12)
        upFollowersCount.text = "2345"
        upFollowersCount.textAlignment = .center
        
        upFollowers.textColor = COLOR_TEXT_HALF_ALPHA
        upFollowers.font = UIFont(name: "Futura-Medium", size: 12)
        upFollowers.text = "Followers"
        upFollowers.textAlignment = .center
        
        upSocultCount.textColor = COLOR_TEXT
        upSocultCount.font = UIFont(name: "Futura-Medium", size: 12)
        upSocultCount.text = "45k"
        upSocultCount.textAlignment = .center
        
        upSocult.textColor = COLOR_TEXT_HALF_ALPHA
        upSocult.font = UIFont(name: "Futura-Medium", size: 12)
        upSocult.text = "Socult"
        upSocult.textAlignment = .center
        
        upCloutCount.textColor = COLOR_TEXT
        upCloutCount.font = UIFont(name: "Futura-Medium", size: 12)
        upCloutCount.text = "34"
        upCloutCount.textAlignment = .center
        
        upClout.textColor = COLOR_TEXT_HALF_ALPHA
        upClout.font = UIFont(name: "Futura-Medium", size: 12)
        upClout.text = "Clout"
        upClout.textAlignment = .center
        
    
        profileDetailsView.addSubview(upUsername)
        profileDetailsView.addSubview(upImageView)
        profileDetailsView.addSubview(upPostsCount)
        profileDetailsView.addSubview(upPosts)
        profileDetailsView.addSubview(upFollowersCount)
        profileDetailsView.addSubview(upFollowers)
        profileDetailsView.addSubview(upSocultCount)
        profileDetailsView.addSubview(upSocult)
        profileDetailsView.addSubview(upCloutCount)
        profileDetailsView.addSubview(upClout)
    }
    
    
    func showFullImage(of image:UIImage) {
        gridCollectionView.alpha = 0
        //scrollImg.transform = CGAffineTransform(scaleX: 0, y: 0)
        photoDetailsView.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0, options: [], animations:{
            self.fullImageView.image = image
            self.fullImageView.alpha = 1
            self.scrollImg.alpha = 1
            //self.scrollImg.transform = CGAffineTransform(scaleX: 1, y: 1)
            
        }, completion: nil)
        
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [], animations:{
            self.photoDetailsView.alpha = 1
            self.photoDetailsView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
        
        var frame = self.tabBarController?.tabBar.frame
        frame = frame?.offsetBy(dx: 0, dy: (self.tabBarController?.tabBar.frame.height)!)
        UIView.animate(withDuration: 0.4, animations: {
            self.tabBarController?.tabBar.frame = frame!
            self.scrollImg.frame = self.scrollImg.frame.offsetBy(dx: 0, dy: -30)
        })
        
        self.scrollImg.frame = CGRect(x: 5, y: self.view.frame.origin.y - 60, width: self.view.frame.width - 10, height: self.view.frame.size.height - 25)
        self.fullImageView.frame = CGRect(x:0,y:0,width: scrollImg.frame.width,height: scrollImg.frame.height)
        
    }
    
    @objc func hideFullImage() {
        
        
        //animate hiding everything
        UIView.animate(withDuration: 0.4, delay: 0, options: [], animations:{[unowned self] in
            self.scrollImg.alpha = 0
            self.fullImageView.alpha = 0
            self.photoDetailsView.alpha = 0
            }, completion: nil)
        
        //resets the scale so the next picture viewed isnt zoomed in
        scrollImg.zoomScale = 1
        
        //hide the tab bar on image close
        var frame = self.tabBarController?.tabBar.frame
        frame = frame?.offsetBy(dx: 0, dy: -(self.tabBarController?.tabBar.frame.height)!)
        UIView.animate(withDuration: 0.4, animations: {
            self.tabBarController?.tabBar.frame = frame!
            self.scrollImg.frame = self.scrollImg.frame.offsetBy(dx: 0, dy: 30)
            self.gridCollectionView.alpha = 1
        })
    }
    
    
    var rotated:Bool = false
    @objc func changegrid() {
        
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
            self.fullImageView.transform = tr
            self.scrollImg.frame = CGRect(x: 5, y: self.view.frame.origin.y - 60, width: self.view.frame.width - 10, height: self.view.frame.size.height - 25)
            self.fullImageView.frame = CGRect(x:0,y:0,width: scrollImg.frame.width,height: scrollImg.frame.height)
        } else {
            if self.gridLayout.numberOfCellsOnRow == 6 {
                self.gridLayout.numberOfCellsOnRow = 1
                gridCollectionView.collectionViewLayout = gridLayout
            } else {
                self.gridLayout.numberOfCellsOnRow+=1
                gridCollectionView.collectionViewLayout = gridLayout
            }
            self.gridCollectionView.reloadData()
        }
    

        
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            print(scrollView.contentOffset.y)
            if profileDetailsView.frame.minY == 0{
                UIView.animate(withDuration: 0.3, animations: {
                    self.profileDetailsView.frame = self.profileDetailsView.frame.offsetBy(dx: 0, dy: -90)
                    self.upPostsCount.frame = self.upPostsCount.frame.offsetBy(dx: 30, dy: 0)
                    self.upPosts.frame = self.upPosts.frame.offsetBy(dx: 30, dy: 0)
                    self.upFollowersCount.frame = self.upFollowersCount.frame.offsetBy(dx: 30, dy: 0)
                    self.upFollowers.frame = self.upFollowers.frame.offsetBy(dx: 30, dy: 0)
                    self.upSocultCount.frame = self.upSocultCount.frame.offsetBy(dx: 30, dy: 0)
                    self.upSocult.frame = self.upSocult.frame.offsetBy(dx: 30, dy: 0)
                    self.upCloutCount.frame = self.upCloutCount.frame.offsetBy(dx: 30, dy: 0)
                    self.upClout.frame = self.upClout.frame.offsetBy(dx: 30, dy: 0)
                    
                    self.upImageView.frame = self.upImageView.frame.offsetBy(dx: -105, dy: 85)
                    //self.upUsername.frame = self.upUsername.frame.offsetBy(dx: -190, dy: 85)
                
                })
                //self.upUsername.animateToFont(UIFont(name: "Futura-MediumItalic", size: 11)!, withDuration: 0.3)
            }
        } else {
            if profileDetailsView.frame.minY != 0 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.profileDetailsView.frame = self.profileDetailsView.frame.offsetBy(dx: 0, dy: 90)
                    self.upPostsCount.frame = self.upPostsCount.frame.offsetBy(dx: -30, dy: 0)
                    self.upPosts.frame = self.upPosts.frame.offsetBy(dx: -30, dy: 0)
                    self.upFollowersCount.frame = self.upFollowersCount.frame.offsetBy(dx: -30, dy: 0)
                    self.upFollowers.frame = self.upFollowers.frame.offsetBy(dx: -30, dy: 0)
                    self.upSocultCount.frame = self.upSocultCount.frame.offsetBy(dx: -30, dy: 0)
                    self.upSocult.frame = self.upSocult.frame.offsetBy(dx: -30, dy: 0)
                    self.upCloutCount.frame = self.upCloutCount.frame.offsetBy(dx: -30, dy: 0)
                    self.upClout.frame = self.upClout.frame.offsetBy(dx: -30, dy: 0)
                    
                    self.upImageView.frame = self.upImageView.frame.offsetBy(dx: 105, dy: -85)
                    //self.upUsername.frame = self.upUsername.frame.offsetBy(dx: 190, dy: -85)

                })
                //self.upUsername.animateToFont(UIFont(name: "Futura-MediumItalic", size: 25)!, withDuration: 0.3)
            }
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue?, sender: Any?) {
        if let destinationVC: UIViewController = segue?.destination {
            destinationVC.hidesBottomBarWhenPushed = true
            destinationVC.navigationController?.isToolbarHidden = true
        }
    }
    
}


extension UILabel {
    func animateToFont(_ font: UIFont, withDuration duration: TimeInterval) {
        let oldFont = self.font
        self.font = font
        // let oldOrigin = frame.origin
        let labelScale = oldFont!.pointSize / font.pointSize
        let oldTransform = transform
        transform = transform.scaledBy(x: labelScale, y: labelScale)
        // let newOrigin = frame.origin
        // frame.origin = oldOrigin
        //setNeedsUpdateConstraints()
        UIView.animate(withDuration: duration) {
            //    self.frame.origin = newOrigin
            self.transform = oldTransform
            //self.layoutIfNeeded()
        }
    }
}


extension ProfileVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 65
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
        //cell.imageView.image = UIImage.init(named: "\(indexPath.row)")
        //cell.imageView.image = UIImage.init(named: "13")
        //cell.imageView.image = UIImage.init(named: "\(indexPath.row / 4)")
        cell.imageView.image = UIImage.init(named: "\(indexPath.row % 15)")

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


