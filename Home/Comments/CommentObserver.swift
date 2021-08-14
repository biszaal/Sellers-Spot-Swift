import Firebase

class CommentObserver: ObservableObject
{
    var locationViewModel = LocationViewModel()
    
    var dateFormatter = DateFormatter()
    
    func fetchData(postId: String, completionHandler: @escaping (_ posts: [CommentDetails]) -> ())
    {
        let commentsRef = Database.database().reference().child("posts").child(postId).child("postComments")
        
        commentsRef.observe(.value, with:
                                { snapshot in
                                    
                                    var tempComments = [CommentDetails]()
                                    
                                    for child in snapshot.children
                                    {
                                        if let childSnapshot = child as? DataSnapshot,
                                           let dict = childSnapshot.value as? [String:Any],
                                           let id = childSnapshot.key as String?,
                                           let userId = dict["userId"] as? String? ?? "",
                                           let comment = dict["comment"] as? String? ?? "",
                                           let commentDate = dict["date"] as? String? ?? ""
                                        
                                        {
                                            self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                                            let formattedDate = self.dateFormatter.date(from:commentDate) ?? Date()
                                            
                                            tempComments.insert(CommentDetails(id: id, userId: userId, userComment: comment, commentDate: formattedDate), at: 0)
                                            
                                        }
                                    }
                                    return completionHandler(tempComments)
                                })
        { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    
    func addComment(postId: String, userId: String, comment: String)
    {
        let posts = Database.database().reference()
        posts.child("posts").child(postId).child("postComments").childByAutoId().setValue(["userId": userId , "comment": comment, "date": Date().rnDate()])
    }
    
}
