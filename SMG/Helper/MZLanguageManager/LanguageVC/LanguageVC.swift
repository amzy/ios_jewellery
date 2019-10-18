
//
//  LanguageVC.swift
//  Snap2Sell
//
//  Created by Amzad on 21/07/16.
//  Copyright © 2016 Syon Infomedia. All rights reserved.
//

import UIKit
protocol LanguageSelectionDelegate: class {
    func userDidSelectLanguage(_ languageCode:LanguageCode)
}


//class LanguageCell: UITableViewCell {
//
//    @IBOutlet weak var cellImage: UIImageView!
//    @IBOutlet weak var cellTitle: UILabel!
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        cellImage!.layer.cornerRadius = 3
//        cellImage!.clipsToBounds = true
//        if cellImage != nil {
//            cellImage.hidden = true
//        }
//    }
//    override func setSelected(selected: Bool, animated: Bool) {
//        if selected {
//            if cellImage != nil {
//                cellImage.hidden = false
//            }
//        }else {
//            if cellImage != nil {
//                cellImage.hidden = true
//            }
//        }
//    }
//}


class LanguageVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var dataArray = [LanguageCode.english, LanguageCode.russian, LanguageCode.bahasa]
    var selectedLanguage:LanguageCode! = nil

    
    weak var delegate:LanguageSelectionDelegate!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        configureNavigationBar()
        configureTableView()
        registerForLanguageNotifications()
        updateScreenOnLanguageChange(nil)
        let selected = LanguageManager.getLanguage()
        switch selected {
        case .english:
            self.tableView.selectRow(at: IndexPath(row: 0,section:0) , animated: true, scrollPosition:UITableViewScrollPosition.middle)
        case .russian:
            self.tableView.selectRow(at: IndexPath(row: 1,section:0) , animated: true, scrollPosition:UITableViewScrollPosition.middle)
        default:
            self.tableView.selectRow(at: IndexPath(row: 0,section:0) , animated: true, scrollPosition:UITableViewScrollPosition.middle)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
// MARK: - Local Notifications For Language Change
extension LanguageVC  {
    func registerForLanguageNotifications(){
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CountrySelectionVC.updateScreenOnLanguageChange(_:)), name: MZLanguageChangeNotificationKey, object: nil)
//        updateScreenOnLanguageChange(nil)
    }
    func updateScreenOnLanguageChange(_ notification:Notification!) {
        self.tableView.reloadData()
    }
}

// MARK: - UITableView Configuration

extension LanguageVC  {
    func configureTableView() {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.register(UINib(nibName: "CountryCell", bundle: Bundle.main), forCellReuseIdentifier: "CountryCell")
    }
}

// MARK: - UITableViewDelegate
extension LanguageVC :UITableViewDelegate  {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLanguage = self.dataArray[(indexPath as NSIndexPath).row]
    }
}

// MARK: - UITableViewDataSource
extension LanguageVC :UITableViewDataSource  {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let returnValue:Int = self.dataArray.count

        if returnValue == 0{
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            emptyLabel.text = MZLocalizedStringForKey("No record found")
            emptyLabel.numberOfLines = 2
            emptyLabel.font = UIFont.systemFont(ofSize: 22)
            emptyLabel.textAlignment = .center
            emptyLabel.textColor = UIColor.lightGray
            emptyLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.tableView.backgroundView = emptyLabel
            // self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        }else{
            self.tableView.backgroundView = nil
        }
        return returnValue
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if(self.dataArray.count == (indexPath as NSIndexPath).row) && (indexPath as NSIndexPath).row > 0 {
            //Load More Cell Will Load Here
            if let cell: LoadMoreTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LoadMoreTableViewCell") as? LoadMoreTableViewCell {
                cell.activityIndicator.startAnimating()
                return cell
            }
        }
        else {
//            if let cell:CountryCell = tableView.dequeueReusableCellWithIdentifier("CountryCell", forIndexPath: indexPath) as? CountryCell {
//                let cellData = self.dataArray[indexPath.row]
//                cell.cellTitle.text = cellData.name
//                cell.separatorInset = UIEdgeInsetsZero;
//                return cell
//            }
        }
        assert(false, "The dequeued table view cell was of an unknown type!");
        return UITableViewCell();
    }
    @objc(tableView:heightForRowAtIndexPath:)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}


// MARK: - Navigation Configuration
extension LanguageVC  {

    func configureNavigationBar(){
        //---- + -------------- + ----------------------- + ------//
        let navBtn = UIButton(type: UIButtonType.system)
        navBtn.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        navBtn.tintColor = UIColor.white
        navBtn.setImage(UIImage(named: "back"), for:UIControlState())
        //navBtn.addTarget(self, action: Selector("toggleLeft"), forControlEvents: UIControlEvents.TouchUpInside)
        navBtn.addTarget(self, action: #selector(LanguageVC.backButtonPressed), for: UIControlEvents.touchUpInside)
        let sidebarButton = UIBarButtonItem(customView: navBtn)
        navigationItem.leftBarButtonItem = sidebarButton

        //---- + -------------- + --------------------- + --------//

        let rightBtn2 = UIButton(type: UIButtonType.system)
        rightBtn2.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        rightBtn2.tintColor = UIColor.white
        rightBtn2.setImage(UIImage(named: "right"), for:UIControlState())
        rightBtn2.addTarget(self, action: #selector(LanguageVC.submitButtonPressed), for: UIControlEvents.touchUpInside)
        let rightbarButton2 = UIBarButtonItem(customView: rightBtn2)
        self.navigationItem.rightBarButtonItem = rightbarButton2
        self.navigationItem.titleView?.tintColor = UIColor.white

        self.navigationController?.navigationBar.isTranslucent = true
    }
    @objc func submitButtonPressed(){

        if self.delegate  != nil {
            self.delegate.userDidSelectLanguage(selectedLanguage ?? .english)
        }
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    @objc func backButtonPressed(){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    func loadController() {
        let languageVC = LanguageVC(nibName: "LanguageVC", bundle: nil)
        let navController = UINavigationController(rootViewController: languageVC)
        navController.navigationBar.barTintColor = UIColor.appNavigation
        navController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve;
        //languageVC.delegate = self
        self.present(navController, animated: false) { () -> Void in
        }
    }
}
