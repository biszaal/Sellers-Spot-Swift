import Firebase

class UserDataObserver: ObservableObject
{
    private var userId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
    
    @Published var userData = [UserData]()
    
    func fetchData()
    {
        noticObserver()
        
        let db = Firestore.firestore()
        db.collection("users").addSnapshotListener
        { (snap, err) in
            
            self.userData.removeAll()
            
            if err != nil
            {
                print((err?.localizedDescription)!)
                return
            }
            
            for i in snap!.documentChanges
            {
                if i.type == .added
                {
                    let id = i.document.get("id") as! String
                    let name = i.document.get("name") as! String
                    let email = i.document.get("email") as! String
                    let image = i.document.get("image") as! String
                    let friends = i.document.get("friends") as? [String]
                    
                    if id != self.userId
                    {
                        self.userData.append(UserData(id: id, name: name, email: email, image: image, friends: friends))
                    }
                }
            }
            
        }
    }
    
    func addUserData(id: String, name: String, email: String, image: String)
    {
        let db = Firestore.firestore()
        
        db.collection("users").document(id).setData(["id": id, "name": name, "email": email, "image": image])
        { (err) in
            
            if err != nil
            {
                print((err?.localizedDescription)!)
                return
            }
            print("message sent")
        }
    }
    
    func noticObserver()
    {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main)
        { (_) in
            let userId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
            self.userId = userId
        }
    }
    
    @Published var userDetails = UserData(id: "", name: "", email: "", image: "") // get user id and return user details
    
    func getUserDetails(id: String)
    {

        let db = Firestore.firestore()
        let docRef = db.collection("users").document(id)

        docRef.getDocument
        { (document, error) in
            if error == nil
            {
                if let document = document, document.exists
                {
                    let userId = document.get("id") as! String
                    let username = document.get("name") as! String
                    let userEmail = document.get("email") as! String
                    let userImage = document.get("image") as! String
                    //let friends = document.get("friends") as! [String]


                    self.userDetails = (UserData(id: userId, name: username, email: userEmail, image: userImage))
                }
            }
            else
            {
                print(error?.localizedDescription as Any)
                return
            }
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
