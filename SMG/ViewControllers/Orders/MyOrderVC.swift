//
//  MyOrderVC.swift
//  SMG
//
//  Created by Amzad Khan on 27/10/18.
//  Copyright © 2018 Amzad Khan. All rights reserved.
//
import UIKit

class MyOrderVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let errorView   = ErrorView.instanceFromNib()
    let emptyView   = EmptyView.instanceFromNib()
    let loadingView = LoadingView.instanceFromNib()
    fileprivate var state = APIState<OrderModel>.loading {
        didSet {
            self.updateTableFooter()
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiLoadOrders()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: - setup View
extension MyOrderVC {
    
    func updateTableFooter() {
        switch self.state {
        case .error(let error):
            errorView.errorLabel.text = error.localizedDescription
            tableView.tableFooterView = errorView
        case .loading:
            tableView.tableFooterView = loadingView
        case .empty:
            tableView.tableFooterView = emptyView
        case .loaded(_):
            tableView.tableFooterView = nil
        }
    }
    
    func setupView(){
        self.title = "MY ORDERS"
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
        // headerContentView.banners = [[:],[:],[:]]
        self.configureTopBar(left: [.leftMenu], right: [.search, .cart])
        NotificationCenter.default.addObserver(self, selector: #selector(self.didUpdateCart), name: .kDidUpdateCart, object: nil)
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
}

// MARK : - TableviewDatasource
extension MyOrderVC : UITableViewDataSource {
    /*func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {if section != 0 {return categories[section]}else {return ""}}*/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        /*return categories.count*/
        if self.state.data != nil {
            return 1
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items  = self.state.data?.orders else {
            return 0
        }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.kOrderCell, for: indexPath) as! OrderCell
        //cell.collectionView.isPagingEnabled = false
        
        guard let items  = self.state.data?.orders else {
            return cell
        }
        let item = items[indexPath.row]
        cell.configureCell(data: item)
        
        return cell
    }
}

// MARK : - TableviewDelegate
extension MyOrderVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let items = self.state.data?.orders else {
            return
        }
        let item = items[indexPath.row]
        let vc = OrderDetailVC.instantiate(fromAppStoryboard: .home)
        vc.orderID = item.orderID
        vc.order = item
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
extension MyOrderVC {
    func apiLoadOrders() {
        if let request = API.getOrders.request(method: .get, with: ["per_page_orders":"20", "current_page":"1"]) {
            Global.showLoadingSpinner(sender: self.view)
            request.responseJSON { response in
                Global.dismissLoadingSpinner(self.view)
                API.getOrders.validatedResponse(response, success: { [weak self] (jsonObject) in
                    guard let strongSelf = self else { return }
                    if let data = jsonObject, let jsonStringData = data.json().data(using: .utf8) {
                        do {
                            let decoder = JSONDecoder()
                            let products = try decoder.decode(OrderModel.self, from: jsonStringData)
                            strongSelf.state = .loaded(products)
                        } catch let err {
                            print("Err", err)
                            strongSelf.state = .error(err)
                        }
                    }else {
                        strongSelf.state = .error(APIError.invalidData)
                    }
                    
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


import XLPagerTabStrip

//MARK:-    IndicatorInfoProvider Method.
extension MyOrderVC : IndicatorInfoProvider {
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: MZLocalizedStringForKey("MY ORDERS")) //CUSTOM ORDERS
    }
}

