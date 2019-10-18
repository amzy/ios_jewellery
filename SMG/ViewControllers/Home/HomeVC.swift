//
//  HomeVC.swift
//  SMG
//
//  Created by Amzad Khan on 29/08/18.
//  Copyright © 2018 Amzad Khan. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    let errorView   = ErrorView.instanceFromNib()
    let emptyView   = EmptyView.instanceFromNib()
    let loadingView = LoadingView.instanceFromNib()
    @IBOutlet var bannerView: BannerView!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var state = APIState<HomeModel>.loading {
        didSet {
            self.updateTableFooter()
            self.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        // Do any additional setup after loading the view.
        self.apiUserDetails()
        self.apiHomeApi()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func reloadData(){
        switch self.state {
        case .loaded(let data):
            self.tableView.tableHeaderView = self.bannerView
            if let sliders = data.sliderData {
                self.bannerView.banners = sliders
            }
        default: break
        }
        
        self.tableView.reloadData()
    }

}
// MARK: - setup View
extension HomeVC {
    
    func setupView(){
        
        self.title = "Home"
        /*self.tblView.estimatedRowHeight = 200 , self.tblView.rowHeight = UITableViewAutomaticDimension*/
        //self.tableView.tableHeaderView = self.bannerView
        // headerContentView.banners = [[:],[:],[:]]
        
        if (User.isUserLogin() != nil) {
            self.configureTopBar(left: [.leftMenu], right: [.filter, .search, .cart, .call])
        }else {
            self.configureTopBar(left: [.login], right: [.filter, .search, .cart, .call])
        }
    
        self.tableView.register(UINib(nibName:Identifiers.kCategoryHeader, bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: Identifiers.kCategoryHeader)
        self.tableView.register(UINib(nibName:Identifiers.kCategoryProductCell, bundle: Bundle.main), forCellReuseIdentifier: Identifiers.kCategoryProductCell)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didUpdateCart), name: .kDidUpdateCart, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.userDidLogin), name: .kDidLoginUser, object: nil)
    }
    @objc func didUpdateCart() {
        guard let user  = Constants.kAppDelegate.user else {return}
        let cartCount  = Int(any:user.cartCount ?? "0")
        if cartCount > 0 {
            self.cartBtn.setBadge(text: user.cartCount)
        }else {
            self.cartBtn.setBadge(text: "")
        }
    }
    @objc func userDidLogin(){
        self.configureTopBar(left: [.leftMenu], right: [.filter, .search, .cart, .call])
    }
    
    func updateTableFooter() {
        switch self.state {
        case .error(let error):
            self.view.backgroundColor = UIColor.white
            errorView.errorLabel.text = error.localizedDescription
            tableView.tableFooterView = errorView
        case .loading:
            self.view.backgroundColor = UIColor.white
            tableView.tableFooterView = loadingView
        case .empty:
            self.view.backgroundColor = UIColor.white
            tableView.tableFooterView = emptyView
        case .loaded(_):
            self.view.backgroundColor = UIColor(hex: "EEEEEE")
            tableView.tableFooterView = nil
        }
    }
}

// MARK: - Page controller & Home all collection details Tap
extension HomeVC: ProductCellDelegate {
    func didSelectItem(cell: UITableViewCell, indexPath: IndexPath) {
        guard let cellIndexPath = tableView.indexPath(for: cell) else { return }
        guard let item = self.state.data?.categories?[cellIndexPath.section].products?[indexPath.row] else {return}
        
        let vc = ProductDetailVC.instantiate(fromAppStoryboard: .home)
        vc.productID = item.productID
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK : - Header View ALL Button Delegate call
extension HomeVC: HeaderDelegate {
    
    func didTapViewAll(_ cell: UIView) {
        
        let point = cell.convert(CGPoint.zero, to: self.tableView!)
        guard let indexPath = self.tableView.indexPathForRow(at: point) else {return}
        print("section = \(String(describing: indexPath.section))")
        guard let item = self.state.data?.categories?[indexPath.section] else {return}
        let vc = ProductListVC.instantiate(fromAppStoryboard: .home)
        vc.catID    = item.termID
        vc.taxonomy = item.taxonomy
        vc.listName = item.name
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK : - Edit Profile APIs
extension HomeVC {
    func apiUserDetails(){
        guard User.isUserLogin() != nil else {return}
        if let request = API.getProfile.request(method: .get, with: [:]) {
            Global.showLoadingSpinner(sender: self.view)
            request.responseJSON { response in
                Global.dismissLoadingSpinner(self.view)
                API.getProfile.validatedResponse(response, success: { (jsonObject) in
                    guard let data = jsonObject?["data"] as? [String:Any] else {return}
                    let user = User.parse(json: data)
                    user.firmAddress = Constants.kAppDelegate.user.firmAddress
                    user.avatar = Constants.kAppDelegate.user.avatar
                    user.saveUser()
                    Constants.kAppDelegate.user = user
                    let cartCount  = Int(any:user.cartCount ?? "0")
                    if cartCount > 0 {
                        self.cartBtn.setBadge(text: user.cartCount)
                    }else {
                        self.cartBtn.setBadge(text: "")
                    }
    
                    }, failed: nil)
            }
        }
    }
    
    func apiHomeApi(){
        let req = API.addToCart.request(parameters: <#T##[[String : Any]]!#>) {
            
        }
        if let request = API.homeProducts.request(method: .get, with: ["user_id":"15"]) {
            Global.showLoadingSpinner(sender: self.view)
            request.responseJSON { response in
                Global.dismissLoadingSpinner(self.view)
                API.homeProducts.validatedResponse(response, success: { [weak self] (jsonObject) in
                    guard let strongSelf = self else { return }
                    var homeData = HomeModel()
                    if let data = jsonObject?["home_slider_data"] as? [String:Any] {
                        if let sliders = data["slides_data"] as? [[String: Any]], let jsonStringData = sliders.json().data(using: .utf8) {
    
                            do {
                                let decoder = JSONDecoder()
                                let sliders = try decoder.decode([Slider].self, from: jsonStringData)
                                homeData.sliderData = sliders
                                
                            } catch let err {
                                print("Err", err)
                            }
                        }
                    }
                    if let data = jsonObject?["data"] as? [[String:Any]], let jsonStringData = data.json().data(using: .utf8) {
                        do {
                            let decoder = JSONDecoder()
                            let sliders = try decoder.decode([Category].self, from: jsonStringData)
                            let filteredCategories = sliders.filter({ (category) -> Bool in
                                guard let products = category.products, products.count > 0 else {return false}
                                return true
                            })
                            homeData.categories = filteredCategories
                            
                        } catch let err {
                            print("Err", err)
                        }
                    }
                    strongSelf.state = .loaded(homeData)
                    }, failed: { [weak self] (error, json) in
                        guard let strongSelf = self else { return }
                        if let errorObj = error {
                            strongSelf.state = .error(errorObj)
                        }
                })
            }
        }
    }
}

// MARK : - TableviewDatasource
extension HomeVC : UITableViewDataSource {
    /*func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {if section != 0 {return categories[section]}else {return ""}}*/
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 40.0 } else { return 40.0 }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView:HeaderHome = tableView.dequeueReusableHeaderFooterView(withIdentifier: Identifiers.kCategoryHeader) as! HeaderHome
        headerView.delegate = self
        guard let data = self.state.data, let categories = data.categories else { return headerView }
        let category = categories[section]
        headerView.headerTitle.text = category.name?.capitalized ?? ""
        return  headerView
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        /*return categories.count*/
        guard let data = self.state.data, let categories = data.categories else { return 0 }
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else { return 1 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.kCategoryProductCell, for: indexPath) as! CategoryProductCell
        //cell.collectionView.isPagingEnabled = false
        if let data = self.state.data, let categories = data.categories {
            let products = categories[indexPath.section].products
            cell.dataSource = products!
            cell.delegate = self
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView.bounds.width / 2) * 1.45
       // if indexPath.section == 2 { return 220} else { return 220 }
    }
}

// MARK : - TableviewDelegate
extension HomeVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { print(indexPath.row) }
    
}

