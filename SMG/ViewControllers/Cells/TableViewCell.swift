import UIKit

public extension Identifiers {
    static let kNotificationCell       = "NotificationCell"
    static let kCategoryProductCell    = "CategoryProductCell"
    static let kOrderCell              = "OrderCell"
    static let kCustomOrderCell              = "CustomOrderCell"
    static let kCartCell               = "CartCell"
    static let kCreditCell             = "CreditCell"
    static let kPromoCodeCell          = "PromoCodeCell"
    static let kPopularCell            = "PopularCell"
    static let kOrderPaymentCell       = "OrderPaymentCell"
    static let kOrderTrackCellTop      = "OrderTrackCellTop"
    static let kOrderTrackCell         = "OrderTrackCell"
    static let kOrderTrackCellBottomo  = "OrderTrackCellBottomo"
}


protocol ProductCellDelegate:NSObjectProtocol {
    func didSelectItem(cell:UITableViewCell, indexPath:IndexPath)
}


class CategoryProductCell : UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate :ProductCellDelegate?
    
    
    
    var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width - ((insets.left) + (insets.right))
    }
    
    var dataSource = [Product]() {
        didSet {
            self.collectionView?.reloadData()
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
         self.collectionView?.register(UINib(nibName:Identifiers.kProductCell, bundle: Bundle.main), forCellWithReuseIdentifier: Identifiers.kProductCell)

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
extension CategoryProductCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let rows = dataSource.count
        if rows == 0 {
            collectionView.setBackgroundMessage("There is currently no collections.")
        } else {
            collectionView.setBackgroundMessage(nil)
        }
        return rows
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.kProductCell, for: indexPath) as? ProductCell
        
        let collection = dataSource[indexPath.row]
        cell?.configureCell(data: collection)
        /*if let url = collection.image.makeURL() {
         cell.imageView.imageWithURL(url: url, placeholder: AssetsImages.kDefaultUpload, handler: nil)
         }else {
         cell.imageView.image = AssetsImages.kDefaultUpload
         }
         
         cell.lblTitle.text = collection.title
         cell.textDescription.text = collection.descriptionText
         */
        //cell.lbl  = AssetsImages.kDefaultUpload
        return cell ?? UICollectionViewCell()
    }

}

// MARK: UICollectionViewDelegate
extension CategoryProductCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if delegate != nil {
            delegate?.didSelectItem(cell: self, indexPath: indexPath)
        }
    }
}

// MARK:- UICollectionViewDelegateFlowLayout
extension CategoryProductCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Load More Cell
        let cellPadding: CGFloat = 0
        var numberOfColumns = CGFloat(2.0)
        if collectionView.isPagingEnabled {
            numberOfColumns = CGFloat(1.0)
        }
        //let width = (contentWidth - (cellPadding * (numberOfColumns + 1))) / numberOfColumns
        let height:CGFloat =  collectionView.height
        let width = height * 0.68
        return CGSize(width: width, height: height)
    }
}


class AccountCell : UITableViewCell {
    @IBOutlet weak var cellTitle    : UILabel!
    @IBOutlet weak var cellSubtitle : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    func configure(data:Any) {
        
    }
}

class NotificationCell : UITableViewCell {
    @IBOutlet weak var cellImage    : UIImageView!
    @IBOutlet weak var cellTitle    : UILabel!
    @IBOutlet weak var cellSubtitle : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    func configure(data:Any) {
        
    }
}

protocol OrderCellDelegate:NSObjectProtocol {
    func didChangeQantity(cell:UITableViewCell, sender:Any)
    func didTapDelete(cell:UITableViewCell, sender:Any)
    func didTapAddToCart(cell:UITableViewCell, sender:Any)
}

import GMStepper
class CartCell : UITableViewCell {
    
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblDeliveryTime: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var bgView           : UIView!
    @IBOutlet weak var productImage     : UIImageView!
    @IBOutlet weak var stepper          : GMStepper!
    @IBOutlet weak var btnDelete        : UIButton!
    @IBOutlet weak var lblProductTitle  : UILabel!
    @IBOutlet weak var lblCode          : UILabel!
    @IBOutlet weak var lblPurity        : UILabel!
    @IBOutlet weak var lblWeight        : UILabel!
    @IBOutlet weak var lblQty: UILabel!
    weak var delegate:OrderCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.stepper?.buttonsFont = UIFont(name: "AvenirNext-Bold", size: 26.0)!
        self.stepper?.labelFont = UIFont(name: "AvenirNext-Bold", size: 14.0)!
    }
    @IBAction func didChangeQantity(_ sender: Any) {
        self.delegate?.didChangeQantity(cell: self, sender: sender)
    }
    
    func configureCell(data:CartItem)  {
        if let url = data.imageURL?.makeURL() {
            self.productImage?.imageWithURL(url: url, placeholder: #imageLiteral(resourceName: "noImg"), handler: nil)
        }else {
            self.productImage?.image = UIImage(named: "place_holder")
        }
        lblProductTitle.text = data.title ?? ""
        lblCode?.text = "SKU : \(data.sku ?? "")"
        lblPurity?.text = "Purity : \(data.purity ?? "")"
        lblDeliveryTime?.text = "Delivery Time : \(data.deliveryTime ?? "") "
        if let weight = data.weight {
            lblWeight?.text = "Net Weight : \(weight)"
        }else {
            lblWeight?.text = ""
        }
        if let size = data.size {
            lblSize?.text = "Size : \(size)"
        }else {
            lblSize?.text = ""
        }
        lblComment?.text = "Remark : \(data.remark ?? "")"
        stepper.value = Double(Int(any:data.qty))
    }
    func configureCell(data:WishListItem)  {
        if let url = data.imageURL?.makeURL() {
            self.productImage?.imageWithURL(url: url, placeholder: #imageLiteral(resourceName: "noImg"), handler: nil)
        }else {
            self.productImage?.image = UIImage(named: "place_holder")
        }
        lblProductTitle.text = data.title ?? ""
        lblCode?.text = "SKU : \(data.sku ?? "")"
        lblPurity?.text = "Purity : \(data.purity ?? "")"
        lblDeliveryTime?.text = "Delivery Time : \(data.deliveryTime ?? "") "
        if let weight = data.weight {
            lblWeight?.text = "Net Weight : \(weight)"
        }else {
            lblWeight?.text = ""
        }
        
        lblSize?.text = "Size : \(data.size)"
       
        lblQty?.text = "Qty : \(data.qty)"
        lblComment?.text = "Remark : \(data.remark ?? "")"
        //stepper?.value = Double(Int(any:data.qty ?? "0"))
    }
    func configureCell(data:OrderProduct)  {
        if let url = data.imageURL?.makeURL() {
            self.productImage?.imageWithURL(url: url, placeholder: #imageLiteral(resourceName: "noImg"), handler: nil)
        }else {
            self.productImage?.image = UIImage(named: "place_holder")
        }
        lblCode?.text = "SKU : \(data.sku ?? "")"
        lblPurity?.text = "Purity : \(data.purity ?? "")"
        lblDeliveryTime?.text = "Delivery Time : \(data.deliveryTime ?? "") "
        if let weight = data.weight {
            lblWeight?.text = "Net Weight : \(weight)"
        }else {
            lblWeight?.text = ""
        }
        lblQty?.text = "Qty : \(data.qty ?? "0")"
        if let size = data.size {
            lblSize?.text = "Size : \(size)"
        }else {
            lblSize?.text = ""
        }
        //stepper?.value = Double(Int(any:data.qty ?? "0"))
    }
    @IBAction func didTapAddToCart(_ sender: Any) {
        self.delegate?.didTapAddToCart(cell: self, sender: sender)
    }
    @IBAction func didTapDelete(_ sender: Any) {
        self.delegate?.didTapDelete(cell: self, sender: sender)
    }
}


class OrderCell : UITableViewCell {
    @IBOutlet weak var bgView           : UIView!
    @IBOutlet weak var lblOrderNumber: UILabel!
    @IBOutlet weak var lblOrderTime: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var btnOrderStatus   : UIButton!
    
    weak var delegate:OrderCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func configureCell(data:Order)  {
        lblOrderTime.text       = "\(data.date)"
        lblOrderNumber?.text    = "Order No. #\(data.orderID)"
        lblWeight?.text         = "Weight : \(data.totalWeight)"
        lblQuantity?.text       = "Quantity: \(data.totalQty)"
        btnOrderStatus.setTitle(data.status.text, for: .normal)
        btnOrderStatus.backgroundColor = data.status.color
        lblWeight?.text = "" +  "Weight : \(data.totalWeight)"
    }
}
class CreditCell : UITableViewCell {
    @IBOutlet weak var cellTitle    : UILabel!
    @IBOutlet weak var cellSubtitle : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    func configure(data:Any) {
        
    }
}

class PromoCodeCell : UITableViewCell {
    @IBOutlet weak var cellTitle    : UILabel!
    @IBOutlet weak var cellSubtitle : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    func configure(data:Any) {
        
    }
}

class PopularCell : UITableViewCell {
    @IBOutlet weak var cellImage    : UIImageView!
    @IBOutlet weak var cellTitle    : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    func configure(data:Any) {
        
    }
}

class OrderTrackCell : UITableViewCell {
    @IBOutlet weak var cellTitle    : UILabel!
    @IBOutlet weak var cellSubtitle : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    func configure(data:Any) {
        
    }
}
class OrderPaymentCell : UITableViewCell {
    @IBOutlet weak var lblOrderPromoCode : UILabel!
    @IBOutlet weak var lblOrderPromoCodeAmount : UILabel!
    @IBOutlet weak var lblOrderTotal : UILabel!
    @IBOutlet weak var lblOrderNetPayment : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    func configure(data:Any) {
        
    }
}

protocol CustomOrderDelegate:NSObjectProtocol {
    func didTapCancel(cell:UITableViewCell)
    func didTapImage(for cell:UITableViewCell, indexPath:IndexPath)
}
class CustomOrderCell : UITableViewCell {
    @IBOutlet weak var lblAdminFeedback: UILabel!
    @IBOutlet weak var bgView           : UIView!
    @IBOutlet weak var lblOrderNumber: UILabel!
    @IBOutlet weak var lblOrderTime: UILabel!
    @IBOutlet weak var lblOrderMessage: UILabel!

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnOrderStatus   : UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate:CustomOrderDelegate?
    var images = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        delegate?.didTapCancel(cell: self)
        
    }
    func configureCell(data:CustomOrder)  {
        lblOrderTime.text       = "\(data.date)"
        lblOrderNumber?.text    = "Order No. #\(data.orderID)"
        lblOrderMessage?.text = "Message: \(data.message)"
        lblAdminFeedback?.text = "Admin Feedback: \(data.feedback ?? "")"
        images = data.images
        btnOrderStatus.setTitle(data.status.text, for: .normal)
        btnOrderStatus.backgroundColor = data.status.color
        self.collectionView.reloadData()
        if data.status == .pending {
            btnCancel.isHidden = false
        }else {
            btnCancel.isHidden = true
        }
        
    }
}

extension CustomOrderCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let rows = images.count
        if rows == 0 {
            collectionView.setBackgroundMessage("There is currently no collections.")
        } else {
            collectionView.setBackgroundMessage(nil)
        }
        return rows
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.kImageCell, for: indexPath) as? ImageCell
        
        if let url = images[indexPath.row].makeURL() {
            cell?.imageView.imageWithURL(url: url, placeholder: AssetsImages.kNoImage, handler: nil)
        }else {
            cell?.imageView.image = AssetsImages.kDefaultUpload
        }

        return cell ?? UICollectionViewCell()
    }
    
}

// MARK: UICollectionViewDelegate
extension CustomOrderCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTapImage(for: self, indexPath: indexPath)
//        if delegate != nil {
//            delegate?.didSelectItem(cell: self, indexPath: indexPath)
//        }
    }
}

// MARK:- UICollectionViewDelegateFlowLayout
extension CustomOrderCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Load More Cell
        let cellPadding: CGFloat = 0
        var numberOfColumns = CGFloat(2.0)
        if collectionView.isPagingEnabled {
            numberOfColumns = CGFloat(1.0)
        }
        //let width = (contentWidth - (cellPadding * (numberOfColumns + 1))) / numberOfColumns
        let height:CGFloat =  collectionView.height
        let width = height * 0.68
        return CGSize(width: width, height: height)
    }
}
