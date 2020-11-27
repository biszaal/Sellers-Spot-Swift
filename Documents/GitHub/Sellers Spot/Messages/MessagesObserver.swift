import Firebase

class MessagesObserver: ObservableObject
{
    var myId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
    
    var userObserver = UserDataObserver()
    
    
    // get last tetx to show in the outside of chatbox
    func lastText(chatId: String, completionHandler: @escaping (_ message: MessagesDataType) -> ())
    {
        let db = Firestore.firestore()
        let queryData = db.collection("data").document("messages").collection(chatId).order(by: "time").limit(toLast: 1)
        
        queryData.addSnapshotListener
        { (snap, err) in
            
            var tempMessage : MessagesDataType = MessagesDataType(id: "", userId: "", message: "", time: "")
            
            if err != nil
            {
                print((err?.localizedDescription)!)
            }
            
            for i in snap!.documentChanges
            {
                if i.type == .added
                {
                    let id = i.document.documentID as String
                    let userId = i.document.get("myId") as? String ?? ""
                    let message = i.document.get("message") as? String ?? ""
                    let time = i.document.get("time") as? String ?? ""
                    
                        tempMessage = MessagesDataType(id: id, userId: userId, message: message, time: time)
                }
            }
            return completionHandler(tempMessage)
        }
    }
    
    func fetchData(chatId: String, messagesData: [MessagesDataType], completionHandler: @escaping (_ messages: [MessagesDataType]) -> ())
    {
        let db = Firestore.firestore()
        let lastMessage = messagesData.first
        var queryData: Query
        
        if lastMessage == nil
        {
            queryData = db.collection("data").document("messages").collection(chatId).order(by: "time").limit(toLast: 20)
        }
        else
        {
            let lastTimeStamp = lastMessage!.time.description
            print(lastMessage!.message)
            queryData = db.collection("data").document("messages").collection(chatId).order(by: "time").end(at: [lastTimeStamp]).limit(toLast: 20)
        }
        
        queryData.addSnapshotListener
        { (snap, err) in
            
            var tempMessages = [MessagesDataType]()
            
            if err != nil
            {
                print((err?.localizedDescription)!)
            }
            
            for i in snap!.documentChanges
            {
                if i.type == .added
                {
                    let id = i.document.documentID as String 
                    let userId = i.document.get("myId") as? String ?? ""
                    let message = i.document.get("message") as? String ?? ""
                    let time = i.document.get("time") as? String ?? ""
                    
                    if id != lastMessage?.id
                    {
                        tempMessages.append(MessagesDataType(id: id, userId: userId, message: message, time: time))
                    }
                }
            }
            return(completionHandler(tempMessages))
        }
    }
    
    // Fetch user messages. Chat locations of the current user and who the user is talking to (their id).
    func getMessageLink(userId: String, completionHandler: @escaping (_ messageLink: [String], _ messageConnection: [String]) -> ())
    {
        let postRef = Database.database().reference().child("users").child(userId)
        postRef.observe(.value, with:
                            { snapshot in
                                
                                var tempMessageLink: [String] = []
                                var tempMessageConnection: [String] = []
                                
                                if let dict = snapshot.value as? [String: Any],
                                let messageConnectionSnapshot = dict["messageLink"] as? NSDictionary?,
                                let messageConnection = messageConnectionSnapshot?.allValues as? [String]? ?? [],
                                let messageLink = messageConnectionSnapshot?.allKeys as? [String]? ?? []
                                {
                                    tempMessageLink = messageLink
                                    tempMessageConnection = messageConnection
                                }
                                
                                return completionHandler(tempMessageLink, tempMessageConnection)
                            })
    }
    
    func addMessage(chatId: String, theirId: String, message: String)
    {
        let db = Firestore.firestore()
        
        // save for message List
        db.collection("data").document("messages").collection(chatId).addDocument(data: ["myId" : self.myId, "message": message, "time": Date().rnDate()])
        
        //save to both user's profile
        userObserver.setChatLocation(userId: myId, chatId: chatId, theirId: theirId)
        
    }
}

struct MessagesDataType: Identifiable, Equatable, Hashable
{
    var id: String
    var userId: String
    var message: String
    var time: String
}
