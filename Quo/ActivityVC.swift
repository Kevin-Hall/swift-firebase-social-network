//
//  ExerciseTable.swift
//  treyn
//
//  Created by Kevin Hall on 9/9/16.
//  Copyright © 2016 Kevin Hall. All rights reserved.
//


    
    import UIKit
    
    class ActivityController: UITableViewController {
        
        static let cellId = "cellId"
        static let headerId = "headerId"
        
        
        
        
        //let week = weekCycleContainer()
        
        
        let containerView: UIView = {
            let container = UIView()
            container.layer.cornerRadius = 0
            container.layer.borderWidth = 0
            container.layer.borderColor = UIColor(white: 0.7, alpha: 1).cgColor
            container.layer.backgroundColor = UIColor.rgb(251, green: 247, blue: 228).cgColor
            return container
        }()

    
        
        override func viewDidLoad() {
            super.viewDidLoad()

            navigationItem.title = "Activity"

            tableView.separatorColor = COLOR_BG
            tableView.sectionHeaderHeight = 30
            
            let path = UIBezierPath(roundedRect:self.view.bounds,byRoundingCorners:[.topLeft,.topRight],cornerRadii: CGSize(width: 10 , height:  10))
            let maskLayer = CAShapeLayer()
            maskLayer.fillColor = COLOR_TEXT.cgColor
            maskLayer.path = path.cgPath
            self.view.layer.mask = maskLayer
            self.navigationController?.view.layer.mask = maskLayer
        
            
            //tableView.contentInset = UIEdgeInsetsMake(133, 0, 100, 0)
            
            tableView.register(FriendRequestCell.self, forCellReuseIdentifier: ActivityController.cellId)
            tableView.register(RequestHeader.self, forHeaderFooterViewReuseIdentifier: ActivityController.headerId)
            
            tableView.backgroundColor = COLOR_BG
            
            self.tableView.tableHeaderView?.frame.size.height = 100 + containerView.bounds.height + (self.navigationController?.navigationBar.bounds.height)!
            
            
            
            //containerView.frame = CGRectMake(0, 50, self.view.frame.width, 150)
            //containerView.addSubview(week)
            //tableView.tableHeaderView = containerView
            
            
            self.navigationController?.view.addSubview(containerView)
            containerView.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: 0)
            //containerView.addSubview(week)
            
            self.navigationController?.navigationBar.isTranslucent = false
            
            
        }
        
        override func numberOfSections(in tableView: UITableView) -> Int {
            return 3
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 10
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell =  tableView.dequeueReusableCell(withIdentifier: ActivityController.cellId, for: indexPath) as! FriendRequestCell
            
            if (indexPath as NSIndexPath).row % 3 == 0 {
                cell.nameLabel.text = "This person followed you"
                cell.requestImageView.image = UIImage(named: "ch")
            } else if (indexPath as NSIndexPath).row % 3 == 1 {
                cell.nameLabel.text = "This person messaged you"
                cell.requestImageView.image = UIImage(named: "ch")
            } else {
                cell.nameLabel.text = "This person copied your status"
                cell.requestImageView.image = UIImage(named: "ch")
            }
            
            cell.nameLabel.textColor = COLOR_TEXT
            cell.imageView?.backgroundColor = UIColor.blue
            cell.imageView?.layer.cornerRadius = 20
            cell.backgroundColor = COLOR_BG
            
            return cell
        }
        
        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 40
        }
        
        override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ActivityController.headerId) as! RequestHeader
            
           //header.backgroundColor = UIColor.rgb(33, green: 33, blue: 33)
            
            
            if section == 0 {
                header.nameLabel.text = "Today"
            } else if section == 1 {
                header.nameLabel.text = "Yesterday"
            } else if section == 2 {
                header.nameLabel.text = "12/7"
            } else if section == 3 {
                header.nameLabel.text = "12/6"
            } else if section == 4 {
                header.nameLabel.text = "BACK"
            } else if section == 5 {
                header.nameLabel.text = "CHEST"
            }




            
            return header
        }
        
    }
    
    class RequestHeader: UITableViewHeaderFooterView {
        
        override init(reuseIdentifier: String?) {
            super.init(reuseIdentifier: reuseIdentifier)
            setupViews()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        let nameLabel: UILabel = {
            let label = UILabel()
            label.text = "EXERCISES"
            label.font = UIFont.systemFont(ofSize: 10)
            label.textColor = COLOR_TEXT_HALF_ALPHA
            return label
        }()
        
        let bottomBorderView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.rgb(229, green: 231, blue: 235)
            return view
        }()
        
        func setupViews() {
            
            addSubview(nameLabel)
            addSubview(bottomBorderView)
            
            addConstraintsWithFormat("H:|-8-[v0]-8-|", views: nameLabel)
            addConstraintsWithFormat("V:|[v0][v1(0.5)]|", views: nameLabel, bottomBorderView)
            
            addConstraintsWithFormat("H:|[v0]|", views: bottomBorderView)
        }
        
    }
    
    class FriendRequestCell: UITableViewCell {
        
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
            label.font = UIFont.boldSystemFont(ofSize: 12)
            return label
        }()
        
        let requestImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
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

extension UIColor {
    
    static func rgb(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
}

extension UIView {
    
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    
}


extension UIImage {
    
    class func imageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}
