import Firebase
import CoreLocation

class PostObserver: ObservableObject
{
    @Published private(set) var posts = [PostDetails]()
    
    var dateFormatter = DateFormatter()
    
    func fetchData(_ numberOfPosts: UInt, searchValue: String? = "")
    {
        let postsRef = Database.database().reference().child("posts")
        var queryRef : DatabaseQuery
        if (searchValue != "")
        {
            queryRef = postsRef.queryOrdered(byChild: "postName").queryStarting(atValue: searchValue)
        } else
        {
            queryRef = postsRef.queryOrdered(byChild: "postDate").queryLimited(toLast: numberOfPosts)
        }
        
        queryRef.observeSingleEvent(of: .value, with:
                            { snapshot in
                                
                                self.posts.removeAll()
                                
                                
                                for child in snapshot.children
                                {
                                    if let childSnapshot = child as? DataSnapshot,
                                       let dict = childSnapshot.value as? [String:Any],
                                       let id = dict["id"] as? String? ?? "",
                                       let userId = dict["userId"] as? String? ?? "",
                                       let username = dict["username"] as? String? ?? "",
                                       let userImage = dict["userImage"] as? String? ?? "",
                                       let productName = dict["postName"] as? String? ?? "",
                                       let productImage = dict["postImage"] as? [String] ?? [],
                                       let productDescription = dict["postDescription"] as? String? ?? "",
                                       let productPrice = dict["postPrice"] as? String? ?? "",
                                       let postedDate = dict["postDate"] as? String? ?? "",
                                       let likeSnapshot = dict["postLike"] as? NSDictionary?,
                                       let postLike = likeSnapshot?.allValues as? [String] ?? [],
                                       let dislikeSnapshot = dict["postDislike"] as? NSDictionary?,
                                       let postDislike = dislikeSnapshot?.allValues as? [String] ?? []
                                    
                                    {
                                        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                                        let postedDate = self.dateFormatter.date(from:postedDate)!
                                        
                                        self.posts.insert(PostDetails(id: id, userId: userId, userName: username, userImage: userImage, postName: productName, postImage: productImage, postDescription: productDescription, postPrice: productPrice, postLocation: "", postDate: postedDate, postLike: postLike, postDislike: postDislike), at: 0)
                                        
                                    }
                                }
                            })
        { (error) in
            print(error.localizedDescription)
        }
    }
    
    // Adding post to the firebase real-time database
    func addPost(id: String, userId: String, username: String, userImage: String, postName: String, postImage: [String], postDescription: String, postPrice: String)
    {
        let posts = Database.database().reference()
        posts.child("posts").child(id).setValue(["id" : id, "userId": userId, "username": username, "userImage": userImage, "postName": postName, "postImage": postImage, "postDescription": postDescription, "postPrice": postPrice, "postLocation": "" ,"postDate": Date().description, "postLike": [], "postDislike": []])
    }
    

    
    func addLikeDislike(postId: String, userId: String, like: Bool, dislike: Bool)
    {
        let posts = Database.database().reference()
        if like
        {
            posts.child("posts").child(postId).child("postLike").child(userId).setValue(userId)
        }
        
        if dislike
        {
            posts.child("posts").child(postId).child("postDislike").child(userId).setValue(userId)
        }
    }
    
    func removeLikeDislike(postId: String, userId: String, like: Bool, dislike: Bool)
    {
        let posts = Database.database().reference()
        if like
        {
            posts.child("posts").child(postId).child("postLike").child(userId).removeValue()
        }
        
        if dislike
        {
            posts.child("posts").child(postId).child("postDislike").child(userId).removeValue()
        }
    }
    

}
