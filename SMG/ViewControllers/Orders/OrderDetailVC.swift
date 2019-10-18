//
//  OrderDetailVC.swift
//  SMG
//
//  Created by Amzad Khan on 28/10/18.
//  Copyright © 2018 Amzad Khan. All rights reserved.
//

import UIKit

class OrderDetailVC: UIViewController {
    var orderID:String!
    var order:Order!
    @IBOutlet weak var btnCheckout: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var cancelHeight: NSLayoutConstraint!
    @IBOutlet weak var lblFeedback: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    let errorView   = ErrorView.instanceFromNib()
    let emptyView   = EmptyView.instanceFromNib()
    let loadingView = LoadingView.instanceFromNib()
    
    fileprivate var state = APIState<OrderDetailModel>.loading {
        didSet {
            self.updateTableFooter()
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        guard let orderID = self.orderID else {
            return
        }
        self.apiLoadOrderItems(orderID: orderID)
        
        if order.status == .pending {
            cancelHeight.constant = 32
        }else {
            cancelHeight.constant = 0
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func didTapCancel(_ sender: Any) {
        guard let order = self.order else {return}
        self.apiCancelOrder(orderID: order.orderID)
    }
    @IBAction func didTapCheckout(_ sender: Any) {
        self.apiPlaceOrder()
    }
}
// MARK: - setup View
extension OrderDetailVC {
    
    func updateTableFooter() {
        switch self.state {
        case .error(let error):
            errorView.errorLabel.text = error.localizedDescription
            tableView.tableFooterView = errorView
        case .loading:
            tableView.tableFooterView = loadingView
        case .empty:
            tableView.tableFooterView = emptyView
        case .loaded(let orderDetail):
            tableView.tableFooterView = nil
            if let feedback  = orderDetail.feedback {
                self.lblFeedback?.text = "   Feedback:" + feedback + "  "
            }else {
                self.lblFeedback?.text = ""
            }
        }
    }
    
    func setupView(){
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.title = "Order Details".uppercased()
        self.configureTopBar(left: [.back], right: [.call])
    }
}


// MARK : - TableviewDatasource
extension OrderDetailVC : UITableViewDataSource {
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
        guard let items  = self.state.data?.products else {
            return 0
        }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.kCartCell, for: indexPath) as! CartCell
        if let items = self.state.data?.products {
            let item  = items[indexPath.row]
            cell.configureCell(data: item)
        }
        cell.delegate = self
        
        //cell.collectionView.isPagingEnabled = false
        return cell
    }
}

// MARK : - TableviewDelegate
extension OrderDetailVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { print(indexPath.row) }
    
}
import GMStepper
extension OrderDetailVC : OrderCellDelegate {
    
    func didTapDelete(cell: UITableViewCell, sender: Any) {
        
    }
    
    func didTapAddToCart(cell: UITableViewCell, sender: Any) {
        
    }
    
    func didChangeQantity(cell: UITableViewCell, sender: Any) {
        
    }
}

// MARK : - Edit Profile APIs
extension OrderDetailVC {
    
    func apiUpdateCartItem(item:CartItem) {
        var data = item.data
        if let request = API.updateCartItemQuantity.request(method: .post, with: data) {
            Global.showLoadingSpinner(sender: self.view)
            request.responseJSON { response in
                Global.dismissLoadingSpinner(self.view)
                API.updateCartItemQuantity.validatedResponse(response, success: { [weak self] (jsonObject) in
                    if let data = jsonObject?["msg"] as? String {
                        Global.showAlert(message:data )
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
    func apiPlaceOrder() {
        
        let params  = [String:Any]()
        if let request = API.updateCartItemQuantity.request(method: .post, with: params) {
            Global.showLoadingSpinner(sender: self.view)
            request.responseJSON { response in
                Global.dismissLoadingSpinner(self.view)
                API.updateCartItemQuantity.validatedResponse(response, success: { [weak self] (jsonObject) in
                    if let data = jsonObject?["msg"] as? String {
                        Global.showAlert(message:data )
                    }
                    self?.state = .error(APIError.emptyDataError)
                    }, failed: { [weak self] (error, json) in
                        guard let strongSelf = self else { return }
                        if let errorObj = error {
                            strongSelf.state = .error(errorObj)
                        }
                })
            }
        }
    }
    
    func apiLoadOrderItems(orderID:String) {
        if let request = API.orderProducts.request(method: .get, with: ["order_id":orderID]) {
            Global.showLoadingSpinner(sender: self.view)
            request.responseJSON { response in
                Global.dismissLoadingSpinner(self.view)
                API.orderProducts.validatedResponse(response, success: { [weak self] (jsonObject) in
                    guard let strongSelf = self else { return }
                    if let data = jsonObject as? [String:Any], let jsonStringData = data.json().data(using: .utf8) {
                        do {
                            let decoder = JSONDecoder()
                            let products = try decoder.decode(OrderDetailModel.self, from: jsonStringData)
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
    func apiCancelOrder(orderID:String) {
       
        if let request = API.cancelOrder.request(method: .get, with: ["order_id":orderID]) {
            Global.showLoadingSpinner(sender: self.view)
            request.responseJSON { response in
                Global.dismissLoadingSpinner(self.view)
                API.cancelOrder.validatedResponse(response, success: { (jsonObject) in
                    if let data = jsonObject?["message"] as? String {
                        Global.showAlert(message: data, handler: { (okay) in
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                    
                }, failed: { [weak self] (error, json) in
                    guard let strongSelf = self else { return }
                    if let data = json?["message"] as? String {
                        Global.showAlert(message: data, handler: { (okay) in
                        
                        })
                    }else {
                        if let errorObj = error {
                            //strongSelf.state = .error(errorObj)
                        }
                    }
                })
            }
        }
        
    }
}
