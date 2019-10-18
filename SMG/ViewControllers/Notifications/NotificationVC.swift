//
//  NotificationVC.swift
//  SMG
//
//  Created by Amzad Khan on 02/09/18.
//  Copyright © 2018 Amzad Khan. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let errorView   = ErrorView.instanceFromNib()
    let emptyView   = EmptyView.instanceFromNib()
    let loadingView = LoadingView.instanceFromNib()
    
    fileprivate var state = UIState.loading {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
// MARK: - setup View
extension NotificationVC {
    
    func setupView(){
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
        // headerContentView.banners = [[:],[:],[:]]
        self.configureTopBar(left: [.leftMenu], right: [.search, .cart])

    }
}

// MARK : - Edit Profile APIs
extension NotificationVC {
    func apiHomeApi(){
        /*
         if let request = API.getHome.request(method: .get, with: nil) {
         Global.showLoadingSpinner(sender: self.view)
         request.responseJSON { response in
         Global.dismissLoadingSpinner(self.view)
         API.getHome.validatedResponse(response, success: { [weak self] (jsonObject) in
         guard let strongSelf = self else { return }
         
         if strongSelf.tags.count > 0 { strongSelf.tags.removeAll() }
         if strongSelf.collections.count > 0{ strongSelf.collections.removeAll()}
         if strongSelf.mytasks.count > 0{ strongSelf.mytasks.removeAll()}
         if let data = jsonObject?["data"] as? [String:Any] {
         if let tags = data["tagTasks"] as? [[String: Any]] {
         for tag in tags {
         let tagObj  = Tag(tag)
         strongSelf.tags.append(tagObj)
         }
         }
         if let collections = data["collections"] as? [[String: Any]] {
         for collection in collections {
         let collection  = Collection(collection)
         strongSelf.collections.append(collection)
         }
         }
         if let taskData = data["allMyTasks"] as? [String: Any], let tasks = taskData["mytask"] as? [[String: Any]] {
         for task in tasks {
         let taskObj = Task(task)
         taskObj.countData = taskData["count"] as? String ?? "0"
         strongSelf.mytasks.append(taskObj)
         }
         }
         }
         strongSelf.state = .success
         }, failed: nil)
         }
         }
         */
    }
}

// MARK : - TableviewDatasource
extension NotificationVC : UITableViewDataSource {
    /*func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {if section != 0 {return categories[section]}else {return ""}}*/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        /*return categories.count*/
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.kNotificationCell, for: indexPath) as! NotificationCell
        //cell.collectionView.isPagingEnabled = false
        return cell
    }
}

// MARK : - TableviewDelegate
extension NotificationVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { print(indexPath.row) }
    
}
