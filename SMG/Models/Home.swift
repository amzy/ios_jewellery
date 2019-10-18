//
//  Home.swift
//  SMG
//
//  Created by Amzad Khan on 12/09/18.
//  Copyright © 2018 Amzad Khan. All rights reserved.
//

import Foundation


public struct Safe<Base: Decodable>: Decodable {
    public let value: Base?
    
    public init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            self.value = try container.decode(Base.self)
        } catch {
            assertionFailure("ERROR: \(error)")
            // TODO: automatically send a report about a corrupted data
            self.value = nil
        }
    }
}


struct Slider : Codable {
    var title:String?
    var excerpt:String?
    var url:String?
    var featuredImgURL:String?
    
    enum CodingKeys: String, CodingKey {
        case title, excerpt, url
        case featuredImgURL = "featured_img_url"
    }
}
extension Slider: BannerDataItem {
    var urlString: String {
        return self.featuredImgURL ?? ""
    }
}

struct ListItem:Codable {
    
    var termID:Int
    var name:String?
    var taxonomy:String?
    enum CodingKeys: String, CodingKey {
        case termID = "term_id"
        case name, taxonomy
    }
}
struct Caret :Codable {
    
    var key:String?
    var val:String
    var grossWeight:String?
    var bangles:String?
    enum CodingKeys: String, CodingKey {
        case grossWeight = "gross_weight"
        case key, val
        case bangles = "number_of_bangle_piece"
    }
}


struct Product : Codable {
    let productID: Int
    let excerpt: String
    let purity: String?
    let sku, weight, title: String?
    let featuredImgURL: String
    
    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case excerpt, purity, sku, weight, title
        case featuredImgURL = "featured_img_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        productID = try container.decode(Int.self, forKey: .productID)
        title = try container.decode(String.self, forKey: .title)
        excerpt = try container.decode(String.self, forKey: .excerpt)
        sku = try container.decode(String.self, forKey: .sku)
        purity = try container.decode(String.self, forKey: .purity)
        weight = try container.decode(String.self, forKey: .weight)
        if let value = try? container.decode(Int.self, forKey: .featuredImgURL) {
            featuredImgURL = String(value)
        } else {
            featuredImgURL = try container.decode(String.self, forKey: .featuredImgURL)
        }
    }
    
}

struct CartItem : Codable {
    
    var productID:String?
    var title:String?
    var excerpt:String?
    var sku:String?
    var purity:String?
    var weight:String?
    var qty:String?
    var cartID:String?
    var imageURL:String?
    var deliveryTime:String?
    var size:String?
    var remark:String?
    
    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case cartID = "cart_id"
        case excerpt, purity, sku, weight, title, qty,size,remark
        case imageURL = "image_url"
        case deliveryTime = "delivery_time"
    }
    
    /*
     qty=14
     product_id=107
     user_id=14
     cart_id=14
     */
    var data:[String:Any] {
        return ["product_id" : "\(productID ??  "0")", "qty" : qty ?? "", /*"purity" : purity ?? "", "weight" : weight ?? "",*/ "cart_id" : cartID ?? ""]
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        productID  = try container.decode(String.self, forKey: .productID)
        title = try container.decode(String.self, forKey: .title)
        excerpt = try container.decodeIfPresent(String.self, forKey: .excerpt)
        deliveryTime = try container.decodeIfPresent(String.self, forKey: .deliveryTime)
        sku = try container.decode(String.self, forKey: .sku)
        purity = try container.decode(String.self, forKey: .purity)
        weight = try container.decode(String.self, forKey: .weight)
        qty = try container.decode(String.self, forKey: .qty)
        cartID = try container.decode(String.self, forKey: .cartID)
        size = try container.decodeIfPresent(String.self, forKey: .size)
        if let value = try? container.decode(Int.self, forKey: .imageURL) {
            imageURL = String(value)
        } else {
            imageURL = try container.decode(String.self, forKey: .imageURL)
        }
        remark = try container.decodeIfPresent(String.self, forKey: .remark)
    }
    
}
extension CartItem : Equatable {
    static func == (lhs: CartItem, rhs: CartItem) -> Bool {
        guard let lhsID = lhs.cartID, let rhsID  = rhs.cartID else {return false}
        return lhsID == rhsID
    }
}


struct ProductDetail : Codable {
    
    var productCat:[ListItem]?
    var galleryImageURL:[String]?
    var brandCarrot:[Caret]?
    var locations:[ListItem]?
    var size:[ListItem]?
    //var special_occasion:[ListItem]?
    var deliveryTime:String?
    
    var productID:Int
    var name:String?
    var shortDescription:String?
    var description:String?
    var status:String?
    var brandName:String?
    var sku:String?
    var featuredImgURL:String?
    var priority:[ListItem]?
    
    enum CodingKeys: String, CodingKey {
        case description, locations
        case shortDescription = "short_description"
        case featuredImgURL = "featured_img_url"
        case galleryImageURL = "gallery_image_url"
        case brandName = "brand_name"
        case sku, size
        case brandCarrot = "brand_carrot"
        case productID = "product_id"
        case deliveryTime = "delivery_time"
        case productCat = "product_cat"
        case name, status
        case priority
    }
    
}

struct Category : Codable {
    
    var termID:TermID
    var name:String?
    var count:Int
    var taxonomy:String?
    var description:String?
    var status:Bool
    var userID:String?
    var msg:String?
    var products:[Product]?
    
    enum CodingKeys: String, CodingKey {
        case status
        case userID = "user_id"
        case count, msg
        case termID = "term_id"
        case description
        case products = "product_data"
        case name, taxonomy
    }
}

struct HomeModel : Codable {
    var sliderData:[Slider]?
    var categories:[Category]?
}

enum TermID: Codable {
    case integer(Int)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(TermID.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for TermID"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}


struct OrderModel : Codable {
    var orders:[Order]?
    var paging:PaginationData?
    enum CodingKeys: String, CodingKey {
        case orders = "data"
        case paging = "pagination_data"
    }
}

struct PaginationData: Codable {
    let currentPage: String
    let pages, currentlyShowing: Int
    let total: String
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case pages
        case currentlyShowing = "currently_showing"
        case total
    }
}
import UIKit

enum OrderStatus :String,Codable  {
    
    case pending  = "1"
    case accepted = "2"
    case completed = "3"
    case rejected  = "4"
    case cancelled  = "5"
    
    var color :UIColor {
        get {
            switch self {
            case .pending :  return UIColor(hex:"#f4de16")
            case .accepted : return UIColor(hex:"#8DC63F")
            case .completed : return UIColor(hex:"#45740")
            case .rejected : return UIColor(hex:"#e91d2b")
            case .cancelled : return UIColor(hex:"#e91d2b")
            }
        }
    }
    var text :String {
        get {
            switch self {
            case .pending:  return "Pending"
            case .accepted: return "Accepted"
            case .completed: return "Completed"
            case .rejected: return "Rejected"
            case .cancelled: return "Cancelled"
            }
        }
    }
    
    init(from decoder: Decoder) throws {
        
        if let label = try? decoder.singleValueContainer().decode(String.self) {
            switch label {
            case "1": self = .pending
            case "2": self = .accepted
            case "3": self = .completed
            case "4": self = .rejected
            case "5": self = .cancelled
            default: self  = .pending
                // default: self = .other(label)
            }
        }else {
            
         let label = try decoder.singleValueContainer().decode(Int.self)
            switch label {
            case 1: self = .pending
            case 2: self = .accepted
            case 3: self = .completed
            case 4: self = .rejected
            case 5: self = .cancelled
            default: self = .pending
                // default: self = .other(label)
            }
        }
        
    }
}


struct Order: Codable {
    let totalWeight, orderID, date: String
    let status:OrderStatus
    let weightUnit: String
    let userID, totalQty: String
    
    enum CodingKeys: String, CodingKey {
        case totalWeight = "total_weight"
        case orderID = "order_id"
        case status, date
        case weightUnit = "weight_unit"
        case userID = "user_id"
        case totalQty = "total_qty"
    }
}

struct CustomOrderModel : Codable {
    var orders:[CustomOrder]?
    var paging:PaginationData?
    enum CodingKeys: String, CodingKey {
        case orders = "data"
        case paging = "pagination_data"
    }
}

struct CustomOrder: Codable {
    let orderID: Int
    let status:OrderStatus
    let images: [String]
    let totalImage: Int
    let feedback: String?
    let message, date: String
    
    enum CodingKeys: String, CodingKey {
        case status
        case orderID = "order_id"
        case images
        case totalImage = "total_image"
        case feedback, message, date
    }
}


struct WishListModel : Codable {
    var products:[WishListItem]?
    var paging:PaginationData?
    enum CodingKeys: String, CodingKey {
        case products = "product_info"
        case paging = "pagination_data"
    }
}

struct WishListItem: Codable {
    let wishlistID: String
    let imageURL: String?
    let sku, title: String
    var qty:String
    var weight:String?
    var itemCount:String
    var purity:String
    let size, productID: String
    let remark, deliveryTime: String?
    
    enum CodingKeys: String, CodingKey {
        case wishlistID = "wishlist_id"
        case imageURL = "image_url"
        case sku, weight, title, qty, size
        case productID = "product_id"
        case itemCount = "item_count"
        case purity, remark
        case deliveryTime = "delivery_time"
    }
}
extension WishListItem : Equatable {
    static func == (lhs: WishListItem, rhs: WishListItem) -> Bool {
        return lhs.wishlistID == rhs.wishlistID
    }
}

struct OrderDetailModel : Codable {
    var products:[OrderProduct]
    var feedback:String?
    enum CodingKeys: String, CodingKey {
        case products = "products"
        case feedback = "feedback"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let products  = try container.decodeIfPresent([OrderProduct].self, forKey: .products) {
            self.products = products
        }else {
            self.products = [OrderProduct]()
        }
        
        feedback = try container.decodeIfPresent(String.self, forKey: .feedback)
    }
}
struct OrderProduct: Codable {
    let productSerial: Int
    let imageURL: String?
    let userID, orderID, weight, qty: String?
    let size, productID, remark, purity: String?
    let date: String?
    let sku, deliveryTime: String?
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case productSerial = "product_serial"
        case imageURL = "image_url"
        case userID = "user_id"
        case orderID = "order_id"
        case weight, qty, size
        case productID = "product_id"
        case remark, purity, date, sku
        case deliveryTime = "delivery_time"
        case status
    }
}
