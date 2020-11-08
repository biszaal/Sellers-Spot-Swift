import Firebase

class MessagesObserver: ObservableObject
{
    var myId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
    
    var userObserver = UserDataObserver()
    
    func fetchList(chatId: String, completionHandler: @escaping (_ messages: Messages) -> ())
    {
        let db = Firestore.firestore()
        db.collection("messages").document(chatId).addSnapshotListener
        { (snap, err) in
            
            var tempMessageList = Messages(id: "", userOne: "", userTwo: "", message: "", time: Date())
            
            if err != nil
            {
                print((err?.localizedDescription)!)
                return
            }
            let chatId = snap?.get("chatId") as? String ?? ""
            let userOne = snap?.get("userOne") as? String ?? ""
            let userTwo = snap?.get("userTwo") as? String ?? ""
            let message = snap?.get("recentMessage") as? String ?? ""
            let date = snap?.get("time") as? String ?? ""
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let time = dateFormatter.date(from: date) ?? Date()
            
            tempMessageList = Messages(id: chatId, userOne: userOne, userTwo: userTwo, message: message, time: time)
            
            return completionHandler(tempMessageList)
        }
    }
    
    func fetchData(chatId: String, completionHandler: @escaping (_ messages: [MessagesDataType]) -> ())
        {
            let db = Firestore.firestore()
        db.collection("messages").document(chatId).collection("texts").order(by: "time").limit(toLast: 10).addSnapshotListener
                { (snap, err) in
    
                var tempMessages = [MessagesDataType]()
    
                    if err != nil
                    {
                        print((err?.localizedDescription)!)
                        return
                    }
    
                    for i in snap!.documentChanges
                    {
                        if i.type == .added
                        {
                            let id = i.document.get("myId") as? String ?? ""
                            let message = i.document.get("message") as? String ?? ""
                            let time = i.document.get("time") as? String ?? ""
    
                            tempMessages.append(MessagesDataType(id: id, message: message, time: time))
                        }
                    }
                return(completionHandler(tempMessages))
            }
        }
    
    func addMessage(chatId: String, theirId: String, message: String)
    {
        let db = Firestore.firestore()
        
        // save for message List
        db.collection("messages").document(chatId).setData(["chatId": chatId, "userOne": self.myId, "userTwo": theirId, "recentMessage": message, "time": Date().rnDate()])
        { (err) in
            
            if err != nil
            {
                print((err?.localizedDescription)!)
                return
            }
            print("message sent")
        }
        
        // save for chat box
        db.collection("messages").document(chatId).collection("texts").addDocument(data: ["myId" : self.myId, "message": message, "time": Date().rnDate()])
        
        //save to both user's profile
        userObserver.setChatLocation(userId: myId, chatId: chatId, theirId: theirId)
        userObserver.setChatLocation(userId: theirId, chatId: chatId, theirId: myId)
        
    }
}

struct MessagesDataType: Identifiable, Equatable, Hashable
{
    var id: String
    var message: String
    var time: String
}


struct Messages: Identifiable, Equatable
{
    var id: String
    var userOne: String
    var userTwo: String
    var message: String
    var time: Date
}
