import Firebase
import CoreLocation

class PostObserver: ObservableObject
{
    //@Published var posts = [PostDetails]()
    
    var dateFormatter = DateFormatter()
    
    func fetchData(searchValue: String, posts: [PostDetails], completionHandler: @escaping (_ posts: [PostDetails]) -> ())
    {
        let postsRef = Database.database().reference().child("posts")
        let lastPost = posts.last
        var queryRef : DatabaseQuery
        if (searchValue != "")
        {
            queryRef = postsRef.queryOrdered(byChild: "postName").queryEqual(toValue: searchValue)
        } else
        {
            if lastPost == nil
            {
                queryRef = postsRef.queryOrdered(byChild: "postDate").queryLimited(toLast: 20)
            }
            else
            {
                let lastTimeStamp = lastPost!.postDate.description
                queryRef = postsRef.queryOrdered(byChild: "postDate").queryEnding(atValue: lastTimeStamp).queryLimited(toLast: 20)
            }
        }
        
        queryRef.observeSingleEvent(of: .value, with:
                                        { snapshot in
                                            
                                            var tempPosts = [PostDetails]()
                                            
                                            for child in snapshot.children
                                            {
                                                if let childSnapshot = child as? DataSnapshot,
                                                   let dict = childSnapshot.value as? [String:Any],
                                                   let id = childSnapshot.key as String?,
                                                   let userId = dict["userId"] as? String ?? "",
                                                   let productName = dict["postName"] as? String ?? "",
                                                   let productLocation = dict["postLocation"] as? String ?? "",
                                                   let productImage = dict["postImage"] as? [String] ?? [],
                                                   let productDescription = dict["postDescription"] as? String ?? "",
                                                   let productPrice = dict["postPrice"] as? String ?? "",
                                                   let postedDate = dict["postDate"] as? String ?? "",
                                                   let likeSnapshot = dict["postLike"] as? NSDictionary?,
                                                   let postLike = likeSnapshot?.allValues as? [String] ?? [],
                                                   let dislikeSnapshot = dict["postDislike"] as? NSDictionary?,
                                                   let postDislike = dislikeSnapshot?.allValues as? [String] ?? []
                                                {
                                                    if childSnapshot.key != lastPost?.id
                                                    {
                                                        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                                                        let postedDate = self.dateFormatter.date(from:postedDate) ?? Date()
                                                        
                                                        tempPosts.insert(PostDetails(id: id, userId: userId, postName: productName, postImage: productImage, postDescription: productDescription, postPrice: Float(productPrice) ?? 0.0, postLocation: productLocation, postDate: postedDate, postLike: postLike, postDislike: postDislike), at: 0)
                                                    }
                                                }
                                            }
                                            return completionHandler(tempPosts)
                                        })
        { (error) in
            print(error.localizedDescription)
        }
    }
    
    // Adding post to the firebase real-time database
    func addPost(id: String, userId: String, username: String, userImage: String, postName: String, postLocation: String, postImage: [String], postDescription: String, postPrice: String)
    {
        let posts = Database.database().reference()
        posts.child("posts").child(id).setValue(["userId": userId, "postName": postName, "postImage": postImage, "postDescription": postDescription, "postPrice": postPrice, "postLocation": postLocation ,"postDate": Date().rnDate(), "postLike": [], "postDislike": []])
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
