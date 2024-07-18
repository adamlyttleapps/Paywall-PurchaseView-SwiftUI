# Paywall-PurchaseView-SwiftUI

PurchaseView is a SwiftUI view for implementing a premium access purchase screen in your iOS app. This screen offers a user-friendly way to present subscription options, handle purchase transactions, and restore purchases.

## Features

* Customizable UI: Easily modify the view to fit your app’s design.
* Animated Hero Image: Includes a shaking effect for the hero image.
* Dynamic Content: Displays product details dynamically based on the available purchase options.
* Subscription Management: Handles purchasing and restoring subscriptions.
* Trial Support: Displays trial information and adjusts the call to action accordingly.
* Cooldown Timer: Prevents immediate closing of the purchase view, encouraging interaction.

## How to Use

The best way to present `PurchaseView` is using a full-screen cover. Here’s an example:

```
.fullScreenCover(isPresented: $showPurchaseSheet) {
    PurchaseView(isPresented: $showPurchaseSheet)
}
```

# Customization

## Customizing Features

The features displayed in the PurchaseView can be customized by modifying the PurchaseFeatureView instances within the body of PurchaseView. Each feature is defined by a title, an icon, and a color.

```
VStack (alignment: .leading) {
    PurchaseFeatureView(title: "Add first feature here", icon: "star", color: color)
    PurchaseFeatureView(title: "Then add second feature", icon: "star", color: color)
    PurchaseFeatureView(title: "Put final feature here", icon: "star", color: color)
    PurchaseFeatureView(title: "Remove annoying paywalls", icon: "lock.square.stack", color: color)
}
.font(.system(size: 19))
.padding(.top)
```

To customize, simply change the title, icon, and color parameters:

```
PurchaseFeatureView(title: "New Feature", icon: "new.icon", color: .green)
```

## Customizing the Title

The main title displayed in the PurchaseView can be customized by modifying the Text view in the body:

```
Text("Unlock Premium Access")
    .font(.system(size: 30, weight: .semibold))
    .multilineTextAlignment(.center)
```

To customize, change the string “Unlock Premium Access” to your desired title:

```
Text("Your Custom Title")
```

# Customizing Purchase Functionality

## PurchaseModel.swift

The PurchaseModel class manages the purchase data and state. You can customize the purchase functionality by modifying methods in this class.

## Initializing Products

You can set up your product IDs and details in the init() method:

```
init() {
    self.productIds = ["your_product_id_1", "your_product_id_2"]
    self.productDetails = [
        PurchaseProductDetails(price: "$9.99", productId: "your_product_id_1", duration: "month", durationPlanName: "Monthly Plan", hasTrial: true),
        PurchaseProductDetails(price: "$99.99", productId: "your_product_id_2", duration: "year", durationPlanName: "Yearly Plan", hasTrial: false)
    ]
}
```

Replace "your_product_id_1", "your_product_id_2", and the corresponding details with your actual product information.

## Handling Purchases

To customize the purchase process, modify the purchaseSubscription method:

```
func purchaseSubscription(productId: String) {
    // Trigger purchase process
    // Implement your purchase logic here
}
```

Insert your in-app purchase logic within this method to handle the subscription process.

## Restoring Purchases

To customize the restore purchases functionality, modify the restorePurchases method:

```
func restorePurchases() {
    // Trigger restore purchases
    // Implement your restore logic here
}
```

Insert your restore purchases logic within this method to handle restoring previous purchases.

# About

Created by Adam Lyttle

Twitter: [https://x.com/adamlyttleapps](adamlyttleapps)

## Contributions

Contributions are welcome! Feel free to open an issue or submit a pull request on the [GitHub repository](https://github.com/adamlyttleapps/Paywall-PurchaseView-SwiftUI).

## MIT License

This project is licensed under the MIT License. See the LICENSE file for more details.

This README provides a clear overview of the project, detailed usage instructions, and additional sections like examples, contributions, and licensing, making it more comprehensive and user-friendly.
