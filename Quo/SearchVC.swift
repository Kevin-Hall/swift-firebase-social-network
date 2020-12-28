//
//  SearchVC.swift
//  Quo
//
//  Created by Kevin Hall on 10/5/17.
//  Copyright © 2017 KAACK. All rights reserved.
//
import Foundation
import UIKit
import Firebase

class SearchVC: UITableViewController {
    
    static let cellId = "cellId"
    static let headerId = "headerId"
    
    var uid = [String]()
    var usernames = [String]()
    var photourls = [String]()
    
    
    //let week = weekCycleContainer()
    
    
    
    func retrieveUsers() {
        let ref = DB_BASE
        
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            let users = snapshot.value as! [String : AnyObject]
            //self.user.removeAll()
            for (_, value) in users {
                if let uid = value["uid"] as? String {
                    if uid != Auth.auth().currentUser!.uid {
                        if let username = value["username"] as? String, let photoURL = value["urlToImage"] as? String {

                            self.uid.append(uid)
                            self.usernames.append(username)
                            self.photourls.append(photoURL)
                            print(username)
                        }
                    }
                }
            }
            self.tableView.reloadData()
        })
        ref.removeAllObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveUsers()
        
        navigationItem.title = "Search"
        
        tableView.separatorColor = COLOR_BG
        tableView.sectionHeaderHeight = 30
        
        let path = UIBezierPath(roundedRect:self.view.bounds,byRoundingCorners:[.topLeft,.topRight],cornerRadii: CGSize(width: 10 , height:  10))
        let maskLayer = CAShapeLayer()
        maskLayer.fillColor = COLOR_TEXT.cgColor
        maskLayer.path = path.cgPath
        self.view.layer.mask = maskLayer
        self.navigationController?.view.layer.mask = maskLayer
        
        
        tableView.register(RequestCell.self, forCellReuseIdentifier: ActivityController.cellId)
        tableView.register(RequestHeader.self, forHeaderFooterViewReuseIdentifier: ActivityController.headerId)
        
        tableView.backgroundColor = COLOR_BG
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uid.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: SearchVC.cellId, for: indexPath) as! RequestCell
    
        
        cell.nameLabel.text = usernames[indexPath.row]
        cell.nameLabel.textColor = COLOR_TEXT
        cell.imageView?.backgroundColor = UIColor.blue
        cell.imageView?.layer.cornerRadius = 2
        cell.backgroundColor = COLOR_BG
        
        cell.requestImageView.downloadImage(from: self.photourls[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ActivityController.headerId) as! RequestHeader
        
        //header.backgroundColor = UIColor.rgb(33, green: 33, blue: 33)
        
        
        if section == 0 {
            header.nameLabel.text = "All users"
        }
        
        
        
        
        
        return header
    }
    
}

//class RequestHeader: UITableViewHeaderFooterView {
//
//    override init(reuseIdentifier: String?) {
//        super.init(reuseIdentifier: reuseIdentifier)
//        setupViews()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    let nameLabel: UILabel = {
//        let label = UILabel()
//        label.text = "EXERCISES"
//        label.font = UIFont.systemFont(ofSize: 10)
//        label.textColor = COLOR_TEXT_HALF_ALPHA
//        return label
//    }()
//
//    let bottomBorderView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.rgb(229, green: 231, blue: 235)
//        return view
//    }()
//
//    func setupViews() {
//
//        addSubview(nameLabel)
//        addSubview(bottomBorderView)
//
//        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: nameLabel)
//        addConstraintsWithFormat("V:|[v0][v1(0.5)]|", views: nameLabel, bottomBorderView)
//
//        addConstraintsWithFormat("H:|[v0]|", views: bottomBorderView)
//    }
//
//}
//
class RequestCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample Name"
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    let requestImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.rgb(33, green: 33, blue: 33)
        imageView.layer.cornerRadius = 2
        imageView.layer.masksToBounds = true
        return imageView
    }()

    let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("STATS", for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.backgroundColor = UIColor.rgb(142, green: 0, blue: 28)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.layer.cornerRadius = 2
        button.isHidden = true
        return button
    }()

    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("button", for: UIControlState())
        button.setTitleColor(UIColor(white: 0.8, alpha: 1), for: UIControlState())
        button.layer.cornerRadius = 2
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(white: 0.7, alpha: 1).cgColor
        button.isHidden = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        return button
    }()

    func setupViews() {
        addSubview(requestImageView)
        addSubview(nameLabel)
        addSubview(confirmButton)
        addSubview(deleteButton)

        addConstraintsWithFormat("H:|-16-[v0(52)]-8-[v1]|", views: requestImageView, nameLabel)

        addConstraintsWithFormat("V:|-4-[v0]-4-|", views: requestImageView)

        addConstraintsWithFormat("V:|-8-[v0]-8-[v1(24)]-8-|", views: nameLabel, confirmButton)
        addConstraintsWithFormat("V:|-15-[v0]-8-[v1(0)]-8-|", views: nameLabel, confirmButton)

        addConstraintsWithFormat("H:|-76-[v0(80)]-8-[v1(80)]", views: confirmButton, deleteButton)
        addConstraintsWithFormat("H:|-160-[v0(100)]-8-[v1(80)]", views: confirmButton, deleteButton)

        addConstraintsWithFormat("V:[v0(24)]-8-|", views: deleteButton)

    }

}

extension UIImageView {
    
    func downloadImage(from imgURL: String!) {
        let url = URLRequest(url: URL(string: imgURL)!)
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
            
        }
        
        task.resume()
    }
}


