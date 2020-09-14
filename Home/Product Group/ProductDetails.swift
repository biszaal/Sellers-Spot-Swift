import Foundation

struct ProductDetails: Identifiable
{
    var id: String
    var userName: String
    var userImage: String
    var productName: String
    var productImage: [String]
    var productDescription: String
    var productPrice: Double
}

var productsList: [ProductDetails] = [
    ProductDetails(id: "1", userName: "@biszaal", userImage: "user", productName: "Lamborgini 2020 Model", productImage: ["car1", "car2", "car3", "car4", "car5"], productDescription: "Bought Last year and have ran only 100 miles. No scratches or dents.", productPrice: 2000000.00),
    ProductDetails(id: "2", userName: "@lakku", userImage: "lakku", productName: "Food", productImage: ["food"], productDescription: "It's very tasty", productPrice: 20.00),
    ProductDetails(id: "3", userName: "@bubbly", userImage: "sapana", productName: "Lamborgini 2020 Model", productImage: ["car1", "car2", "car3", "car4", "car5"], productDescription: "Bought Last year and have ran only 100 miles. No scratches or dents.", productPrice: 2000000.00),
    ProductDetails(id: "4", userName: "@stranzer", userImage: "niraj", productName: "Lamborgini 2020 Model", productImage: ["car1", "car2", "car3", "car4", "car5"], productDescription: "Bought Last year and have ran only 100 miles. No scratches or dents.", productPrice: 2000000.00)
]
