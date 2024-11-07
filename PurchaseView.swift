// PurchaseView SwiftUI
// Created by Adam Lyttle on 7/18/2024

// Make cool stuff and share your build with me:

//  --> x.com/adamlyttleapps
//  --> github.com/adamlyttleapps

// Special thanks:

//  --> Mario (https://x.com/marioapps_com) for recommending changes to fix
//      an issue Apple had rejecting the paywall due to excessive use of
//      the word "FREE"

import SwiftUI

struct PurchaseView: View {
    
    @StateObject var purchaseModel: PurchaseModel = PurchaseModel()
    
    @State private var shakeDegrees = 0.0
    @State private var shakeZoom = 0.9
    @State private var showCloseButton = false
    @State private var progress: CGFloat = 0.0

    @Binding var isPresented: Bool
    
    @State var showNoneRestoredAlert: Bool = false
    @State private var showTermsActionSheet: Bool = false

    @State private var freeTrial: Bool = true
    @State private var selectedProductId: String = ""
    
    let color: Color = Color.blue
    
    private let allowCloseAfter: CGFloat = 5.0 //time in seconds until close is allows
    
    var hasCooldown: Bool = true
    
    let placeholderProductDetails: [PurchaseProductDetails] = [
        PurchaseProductDetails(price: "-", productId: "demo", duration: "week", durationPlanName: "week", hasTrial: false),
        PurchaseProductDetails(price: "-", productId: "demo", duration: "week", durationPlanName: "week", hasTrial: false)
    ]
    
    var callToActionText: String {
        if let selectedProductTrial = purchaseModel.productDetails.first(where: {$0.productId == selectedProductId})?.hasTrial {
            if selectedProductTrial {
                return "Start Free Trial"
            }
            else {
                return "Unlock Now"
            }
        }
        else {
            return "Unlock Now"
        }
    }
    
    var calculateFullPrice: Double? {
        if let weeklyPriceString = purchaseModel.productDetails.first(where: {$0.duration == "week"})?.price {
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency

            if let number = formatter.number(from: weeklyPriceString) {
                let weeklyPriceDouble = number.doubleValue
                return weeklyPriceDouble * 52
            }
            
            
        }
        
        return nil
    }
    
    var calculatePercentageSaved: Int {
        if let calculateFullPrice = calculateFullPrice, let yearlyPriceString = purchaseModel.productDetails.first(where: {$0.duration == "year"})?.price {
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency

            if let number = formatter.number(from: yearlyPriceString) {
                let yearlyPriceDouble = number.doubleValue
                
                let saved = Int(100 - ((yearlyPriceDouble / calculateFullPrice) * 100))
                
                if saved > 0 {
                    return saved
                }
                
            }
            
        }
        return 90
    }
    
    var body: some View {
        ZStack (alignment: .top) {
            
            HStack {
                Spacer()
                
                if hasCooldown && !showCloseButton {
                    Circle()
                        .trim(from: 0.0, to: progress)
                        .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                        .opacity(0.1 + 0.1 * self.progress)
                        .rotationEffect(Angle(degrees: -90))
                        .frame(width: 20, height: 20)
                }
                else {
                    Image(systemName: "multiply")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, alignment: .center)
                        .clipped()
                        .onTapGesture {
                            isPresented = false
                        }
                        .opacity(0.2)
                }
            }
            .padding(.top)

            VStack (spacing: 20) {
                
                ZStack {
                    Image("purchaseview-hero")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 150, alignment: .center)
                        .scaleEffect(shakeZoom)
                        .rotationEffect(.degrees(shakeDegrees))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                startShaking()
                            }
                        }
                }
                
                VStack (spacing: 10) {
                    Text("Unlock Premium Access")
                        .font(.system(size: 30, weight: .semibold))
                        .multilineTextAlignment(.center)
                    VStack (alignment: .leading) {
                        PurchaseFeatureView(title: "Add first feature here", icon: "star", color: color)
                        PurchaseFeatureView(title: "Then add second feature", icon: "star", color: color)
                        PurchaseFeatureView(title: "Put final feature here", icon: "star", color: color)
                        PurchaseFeatureView(title: "Remove annoying paywalls", icon: "lock.square.stack", color: color)
                    }
                    .font(.system(size: 19))
                    .padding(.top)
                }
                
                Spacer()
                
                VStack (spacing: 20) {
                    VStack (spacing: 10) {
                        
                        let productDetails = purchaseModel.isFetchingProducts ? placeholderProductDetails : purchaseModel.productDetails
                        
                        ForEach(productDetails) { productDetails in
                            
                            Button(action: {
                                withAnimation {
                                    selectedProductId = productDetails.productId
                                }
                                self.freeTrial = productDetails.hasTrial
                            }) {
                                VStack {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(productDetails.durationPlanName)
                                                .font(.headline.bold())
                                            if productDetails.hasTrial {
                                                Text("then "+productDetails.price+" per "+productDetails.duration)
                                                    .opacity(0.8)
                                            }
                                            else {
                                                HStack (spacing: 0) {
                                                    if let calculateFullPrice = calculateFullPrice, //round down
                                                       let calculateFullPriceLocalCurrency = toLocalCurrencyString(calculateFullPrice),
                                                       calculateFullPrice > 0
                                                    {
                                                        //shows the full price based on weekly calculaation
                                                        Text("\(calculateFullPriceLocalCurrency) ")
                                                            .strikethrough()
                                                            .opacity(0.4)
                                                        
                                                    }
                                                    Text(" " + productDetails.price + " per " + productDetails.duration)
                                                }
                                                .opacity(0.8)
                                            }
                                        }
                                        Spacer()
                                        if productDetails.hasTrial {
                                            //removed: Some apps were being rejected with this caption present:
                                            /*Text("FREE")
                                                .font(.title2.bold())*/
                                        }
                                        else {
                                            VStack {
                                                Text("SAVE \(calculatePercentageSaved)%")
                                                    .font(.caption.bold())
                                                    .foregroundColor(.white)
                                                    .padding(8)
                                            }
                                            .background(Color.red)
                                            .cornerRadius(6)
                                        }
                                        
                                        ZStack {
                                            Image(systemName: (selectedProductId == productDetails.productId) ? "circle.fill" : "circle")
                                                .foregroundColor((selectedProductId == productDetails.productId) ? color : Color.primary.opacity(0.15))
                                            
                                            if selectedProductId == productDetails.productId {
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(Color.white)
                                                    .scaleEffect(0.7)
                                            }
                                        }
                                        .font(.title3.bold())
                                        
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 10)
                                }
                                //.background(Color(.systemGray4))
                                .cornerRadius(6)
                                .overlay(
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke((selectedProductId == productDetails.productId) ? color : Color.primary.opacity(0.15), lineWidth: 1) // Border color and width
                                        RoundedRectangle(cornerRadius: 6)
                                            .foregroundColor((selectedProductId == productDetails.productId) ? color.opacity(0.05) : Color.primary.opacity(0.001))
                                    }
                                )
                            }
                            .accentColor(Color.primary)
                            
                        }
                        
                        HStack {
                            Toggle(isOn: $freeTrial) {
                                Text("Free Trial Enabled")
                                    .font(.headline.bold())
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .onChange(of: freeTrial) { freeTrial in
                                if !freeTrial, let firstProductId = self.purchaseModel.productIds.first {
                                    withAnimation {
                                        self.selectedProductId = String(firstProductId)
                                    }
                                }
                                else if freeTrial, let lastProductId = self.purchaseModel.productIds.last {
                                    withAnimation {
                                        self.selectedProductId = lastProductId
                                    }
                                }
                            }
                        }
                        .background(Color.primary.opacity(0.05))
                        .cornerRadius(6)
                        
                    }
                    .opacity(purchaseModel.isFetchingProducts ? 0 : 1)
                    
                    VStack (spacing: 25) {
                        
                        ZStack (alignment: .center) {
                            
                            //if purchasedModel.isPurchasing {
                            ProgressView()
                                .opacity(purchaseModel.isPurchasing ? 1 : 0)
                            
                            Button(action: {
                                //productManager.purchaseProduct()
                                if !purchaseModel.isPurchasing {
                                    purchaseModel.purchaseSubscription(productId: self.selectedProductId)
                                }
                            }) {
                                HStack {
                                    Spacer()
                                    HStack {
                                        Text(callToActionText)
                                        Image(systemName: "chevron.right")
                                    }
                                    Spacer()
                                }
                                .padding()
                                .foregroundColor(.white)
                                .font(.title3.bold())
                            }
                            .background(color)
                            .cornerRadius(6)
                            .opacity(purchaseModel.isPurchasing ? 0 : 1)
                            .padding(.top)
                            .padding(.bottom, 4)
                            
                            
                        }
                        
                    }
                    .opacity(purchaseModel.isFetchingProducts ? 0 : 1)
                }
                .id("view-\(purchaseModel.isFetchingProducts)")
                .background {
                    if purchaseModel.isFetchingProducts {
                        ProgressView()
                    }
                }
                
                VStack (spacing: 5) {
                    
                    /*HStack (spacing: 4) {
                        Image(systemName: "figure.2.and.child.holdinghands")
                            .foregroundColor(Color.red)
                        Text("Family Sharing enabled")
                            .foregroundColor(.white)
                    }
                    .font(.footnote)*/
                    
                    HStack (spacing: 10) {
                        
                        Button("Restore") {
                            purchaseModel.restorePurchases()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                                if !purchaseModel.isSubscribed {
                                    showNoneRestoredAlert = true
                                }
                            }
                        }
                        .alert(isPresented: $showNoneRestoredAlert) {
                            Alert(title: Text("Restore Purchases"), message: Text("No purchases restored"), dismissButton: .default(Text("OK")))
                        }
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray), alignment: .bottom
                        )
                        .font(.footnote)
                        
                        
                        Button("Terms of Use & Privacy Policy") {
                            showTermsActionSheet = true
                        }
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray), alignment: .bottom
                        )
                        .actionSheet(isPresented: $showTermsActionSheet) {
                            ActionSheet(title: Text("View Terms & Conditions"), message: nil,
                                        buttons: [
                                            .default(Text("Terms of Use"), action: {
                                                if let url = URL(string: "https://example.com") {
                                                    UIApplication.shared.open(url)
                                                }
                                            }),
                                            .default(Text("Privacy Policy"), action: {
                                                if let url = URL(string: "https://example.com") {
                                                    UIApplication.shared.open(url)
                                                }
                                            }),
                                            .cancel()
                                        ])
                        }
                        .font(.footnote)
                        
                        
                    }
                    //.font(.headline)
                    .foregroundColor(.gray)
                    .font(.system(size: 15))
                    
                    
                    
                    
                }

                
            }
        }
        .padding(.horizontal)
        .onAppear {
            selectedProductId = purchaseModel.productIds.last ?? ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation(.easeIn(duration: allowCloseAfter)) {
                    self.progress = 1.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + allowCloseAfter) {
                    withAnimation {
                        showCloseButton = true
                    }
                }
            }
        }
        .onChange(of: purchaseModel.isSubscribed) { isSubscribed in
            if(isSubscribed) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isPresented = false
                }
            }
        }
        .onAppear {
            if(purchaseModel.isSubscribed) {
                isPresented = false
            }
        }
        
        
    }
    
    private func startShaking() {
            let totalDuration = 0.7 // Total duration of the shake animation
            let numberOfShakes = 3 // Total number of shakes
            let initialAngle: Double = 10 // Initial rotation angle
            
            withAnimation(.easeInOut(duration: totalDuration / 2)) {
                self.shakeZoom = 0.95
                DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration / 2) {
                    withAnimation(.easeInOut(duration: totalDuration / 2)) {
                        self.shakeZoom = 0.9
                    }
                }
            }

            for i in 0..<numberOfShakes {
                let delay = (totalDuration / Double(numberOfShakes)) * Double(i)
                let angle = initialAngle - (initialAngle / Double(numberOfShakes)) * Double(i)
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation(Animation.easeInOut(duration: totalDuration / Double(numberOfShakes * 2))) {
                        self.shakeDegrees = angle
                    }
                    withAnimation(Animation.easeInOut(duration: totalDuration / Double(numberOfShakes * 2)).delay(totalDuration / Double(numberOfShakes * 2))) {
                        self.shakeDegrees = -angle
                    }
                }
            }

            // Stop the shaking and reset to 0
            DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) {
                withAnimation {
                    self.shakeDegrees = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                    startShaking()
                }
            }
        }
    
    
    struct PurchaseFeatureView: View {
        
        let title: String
        let icon: String
        let color: Color
        
        var body: some View {
            HStack {
                Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 27, height: 27, alignment: .center)
                .clipped()
                .foregroundColor(color)
                Text(title)
            }
        }
    }

    func toLocalCurrencyString(_ value: Double) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        //formatter.locale = locale
        return formatter.string(from: NSNumber(value: value))
    }

}

#Preview {
    PurchaseView(isPresented: .constant(true))
}
