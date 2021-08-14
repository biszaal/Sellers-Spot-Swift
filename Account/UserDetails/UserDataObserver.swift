import Firebase

class UserDataObserver: ObservableObject
{
    private var myId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
    
    var noUserLink: String = "https://www.allianceplast.com/wp-content/uploads/2017/11/no-image.png"
    
    @Published var userData = [UserData]()
    
    // this will get the user Id and return the image and name of the user
    func getUserDetails(id: String, completionHandler: @escaping (_ posts: UserData) -> ())
    {
        let db = Firestore.firestore()
        let queryData = db.collection("users").document(id)
        queryData.getDocument()
        { (doc, err) in
            
            if err != nil
            {
                print((err?.localizedDescription)!)
            }
            
            guard let doc = doc else {
                return
            }
            
            var tempUserData = UserData(id: "", name: "", email: "", image: "")

            let username = doc.get("name") as? String ?? "No Name"
            let userEmail = doc.get("email") as? String ?? ""
            let userImage = doc.get("image") as? String ?? self.noUserLink
                
            tempUserData = (UserData(id: id, name: username, email: userEmail, image: userImage))
            
            return completionHandler(tempUserData)
        }
    }
    
    // save chatBox Location to the user database
    func setChatLocation(userId: String, chatId: String, theirId: String)
    {
        let db = Database.database().reference()
        db.child("users").child(userId).child("messageLink").child(chatId).setValue(theirId)
        db.child("users").child(theirId).child("messageLink").child(chatId).setValue(userId)
    }
}
