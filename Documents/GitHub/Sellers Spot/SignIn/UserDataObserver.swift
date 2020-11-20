import Firebase

class UserDataObserver: ObservableObject
{
    private var myId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
    
    @Published var userData = [UserData]()
    
    func fetchData(completionHandler: @escaping (_ posts: [UserData]) -> ())
    {
        noticObserver()
        
        let postRef = Database.database().reference().child("users")
        postRef.observeSingleEvent(of: .value, with:
                                    { snapshot in
                                        
                                        var tempUserData = [UserData]()
                                        
                                        for child in snapshot.children
                                        {
                                            if let childSnapShot = child as? DataSnapshot,
                                               let dict = childSnapShot.value as? [String: Any],
                                               let id = childSnapShot.key as String?,
                                               let name = dict["name"] as? String ?? "",
                                               let email = dict["email"] as? String ?? "",
                                               let image = dict["image"] as? String ?? "",
                                               let friends = dict["friends"] as? [String] ?? []
                                            {
                                                if id != self.myId
                                                {
                                                    tempUserData.append(UserData(id: id, name: name, email: email, image: image, friends: friends))
                                                }
                                            }
                                        }
                                        return completionHandler(tempUserData)
                                    })
    }
    
    func addUserData(id: String, name: String, email: String, image: String)
    {
        let db = Database.database().reference()
        
        db.child("users").child(id).setValue(["id": id, "name": name, "email": email, "image": image])
    }
    
    func noticObserver()
    {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main)
        { (_) in
            let userId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
            self.myId = userId
        }
    }
    
    // this will get the user Id and return the image and name of the user
    func getUserDetails(id: String, completionHandler: @escaping (_ posts: UserData) -> ())
    {
        
        let postRef = Database.database().reference().child("users").child(id)
        postRef.observeSingleEvent(of: .value, with:
                                    { snapshot in
                                        
                                        var tempUserData = UserData(id: "", name: "", email: "", image: "")
                                        
                                               if let dict = snapshot.value as? [String: Any],
                                               let userId = snapshot.key as String?,
                                               let username = dict["name"] as? String ?? "",
                                               let userEmail = dict["email"] as? String ?? "",
                                               let userImage = dict["image"] as? String ?? "",
                                               let messageConnectionSnapshot = dict["messageLinks"] as? NSDictionary?,
                                               let messageConnection = messageConnectionSnapshot?.allValues as? [String]? ?? [],
                                               let userMessages = messageConnectionSnapshot?.allKeys as? [String]? ?? []
                                            {
                                                    tempUserData = (UserData(id: userId, name: username, email: userEmail, image: userImage, messageId: userMessages, messageConnection: messageConnection))
                                            }
                                        
                                        return completionHandler(tempUserData)
                                    })
    }
    
    // save chatBox Location to the user database
    func setChatLocation(userId: String, chatId: String, theirId: String)
    {
        let db = Database.database().reference()
        db.child("users").child(userId).child("messageLinks").child(chatId).setValue(theirId)
        db.child("users").child(theirId).child("messageLinks").child(chatId).setValue(userId)
    }
    
}

struct UserData: Identifiable
{
    var id: String
    var name: String
    var email: String
    var image: String
    var messageId: [String]?
    var messageConnection: [String]?
    var friends: [String]?
}
