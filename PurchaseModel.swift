// PurchaseModel SwiftUI
// Created by Adam Lyttle on 7/18/2024

// Make cool stuff and share your build with me:

//  --> x.com/adamlyttleapps
//  --> github.com/adamlyttleapps

import Foundation
import StoreKit

class PurchaseModel: ObservableObject {
    
    @Published var productIds: [String]
    @Published var productDetails: [PurchaseProductDetails] = []

    @Published var isSubscribed: Bool = false
    @Published var isPurchasing: Bool = false
    @Published var isFetchingProducts: Bool = false
    
    init() {

        //initialise your productids and product details
        self.productIds = ["demo_y", "demo_w"]
        self.productDetails = [
            PurchaseProductDetails(price: "$25.99", productId: "demo_y", duration: "year", durationPlanName: "Yearly Plan", hasTrial: false),
            PurchaseProductDetails(price: "$4.99", productId: "demo_w", duration: "week", durationPlanName: "3-Day Trial", hasTrial: true)
        ]

    }
    
    func purchaseSubscription(productId: String) {
        //trigger purchase process
    }
    
    func restorePurchases() {
        //trigger restore purchases
    }
    
}

class PurchaseProductDetails: ObservableObject, Identifiable {
    let id: UUID
    
    @Published var price: String
    @Published var productId: String
    @Published var duration: String
    @Published var durationPlanName: String
    @Published var hasTrial: Bool
    
    init(price: String = "", productId: String = "", duration: String = "", durationPlanName: String = "", hasTrial: Bool = false) {
        self.id = UUID()
        self.price = price
        self.productId = productId
        self.duration = duration
        self.durationPlanName = durationPlanName
        self.hasTrial = hasTrial
    }
    
}

