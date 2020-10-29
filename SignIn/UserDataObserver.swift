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
                                               let id = dict["id"] as? String ?? "",
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
                                               let userId = dict["id"] as? String ?? "",
                                               let username = dict["name"] as? String ?? "",
                                               let userEmail = dict["email"] as? String ?? "",
                                               let userImage = dict["image"] as? String ?? ""
                                            {
                                                    tempUserData = (UserData(id: userId, name: username, email: userEmail, image: userImage))
                                            }
                                        
                                        return completionHandler(tempUserData)
                                    })
    }
    
    // save chatBox Location to the user database
    func setChatLocation(userId: String, chatId: String)
    {
        let db = Database.database().reference()
        db.child("users").child(userId).child("messageLinks").child(chatId).setValue(chatId)
    }
    
    //get all the message Locations from the given user
    func getChatLocation(userId: String, completionHandler: @escaping (_ posts: [String]) -> ())
    {
        let postRef = Database.database().reference().child("users").child(userId).child("messageLinks")
        postRef.observe(.value)
        { snapshot in
            
            var tempMessageLink: [String] = []
            
            for child in snapshot.children
            {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? String ?? ""
                    {
                    tempMessageLink.append(dict)
                    }
            }
            return completionHandler(tempMessageLink)
        }
    }
}

struct UserData: Identifiable
{
    var id: String
    var name: String
    var email: String
    var image: String
    var friends: [String]?
}
