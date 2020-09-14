import Firebase

class MessagesObserver: ObservableObject
{
    @Published var messages = [MessagesDataType]()
    
    init()
    {
        let db = Firestore.firestore()
        
        db.collection("messages").addSnapshotListener
            { (snap, err) in
                
                if err != nil
                {
                    print((err?.localizedDescription)!)
                    return
                }
                
                for i in snap!.documentChanges
                {
                    if i.type == .added
                    {
                        let name = i.document.get("name") as! String
                        let image = i.document.get("image") as! String?
                        let message = i.document.get("message") as! String
                        let id = i.document.documentID
                        
                        self.messages.append(MessagesDataType(id: id, name: name, image: image ?? "", message: message))
                        
                    }
                }
        }
    }
    
    func addMessage(message: String, user: String, image: String)
    {
        let db = Firestore.firestore()
        
        db.collection("messages").addDocument(data: ["message": message, "name": user, "image": image])
        { (err) in
            
            if err != nil
            {
                print((err?.localizedDescription)!)
                return
            }
            print("success")
        }
    }
}

struct MessagesDataType: Identifiable
{
    var id: String
    var name: String
    var image: String
    var message: String
}
