
import Firebase

class PostObserver: ObservableObject
{
    @Published var posts = [ProductDetails]()
    
    init()
    {
        let db = Firestore.firestore()
        db.collection("posts").addSnapshotListener
        { [self] (snap, err) in
                
                if err != nil
                {
                    print((err?.localizedDescription)!)
                    return
                }
                
                for i in snap!.documentChanges
                {
                    if i.type == .added
                    {
                        let username = i.document.get("username") as! String
                        let userImage = i.document.get("userImage") as! String
                        let productName = i.document.get("productName") as! String
                        let productImage = i.document.get("productImage") as! [String]
                        let productDescription = i.document.get("productDescription") as! String
                        let productPrice = i.document.get("productPrice") as! String
                        let id = i.document.documentID
                        
                        self.posts.append(ProductDetails(id: id, userName: username, userImage: userImage, productName: productName, productImage: productImage, productDescription: productDescription, productPrice: productPrice, postedDate: rnDate()))
                        
                    }
                }
        }
    }
    
    func addPost(username: String, userImage: String, productName: String, productImage: [String], productDescription: String, productPrice: String)
    {
        let db = Firestore.firestore()
        
        db.collection("posts").addDocument(data: ["username": username, "userImage": userImage, "productName": productName, "productImage": productImage, "productDescription": productDescription, "productPrice": productPrice, "postDate": rnDate()])
        { (err) in
            
            if err != nil
            {
                print((err?.localizedDescription)!)
                return
            }
            print("success")
        }
    }
    
    func rnDate() -> String
    {
        let isoFormatter = DateFormatter()
        isoFormatter.dateFormat = "yyyy.MM.dd.HH.mm.ss.Z"
        
        let date = isoFormatter.string(from: Date())
        return date
    }
}
