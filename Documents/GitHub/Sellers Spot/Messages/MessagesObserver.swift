import Firebase

class MessagesObserver: ObservableObject
{
    var myId: String = UserDefaults.standard.string(forKey: "userId") ?? ""
    
    var userObserver = UserDataObserver()
    
    
    // get last tetx to show in the outside of chatbox
    func lastText(chatId: String, completionHandler: @escaping (_ message: MessagesDataType) -> ())
    {
        let messagesRef = Database.database().reference().child("messages").child(chatId)
        let quertRef = messagesRef.queryOrdered(byChild: "time").queryLimited(toLast: 1)
        
        quertRef.observe(.value)
        { snap in
            
            var tempMessage: MessagesDataType = MessagesDataType(id: "", userId: "", message: "", time: "")
            
            for child in snap.children
            {
                if let childSnapshot = child as? DataSnapshot,
                   let dict = childSnapshot.value as? [String:Any],
                   let id = childSnapshot.key as String? ?? "",
                   let userId = dict["myId"] as? String ?? "",
                   let message = dict["message"] as? String ?? "",
                   let time = dict["time"] as? String ?? ""
                {
                    tempMessage = MessagesDataType(id: id, userId: userId, message: message, time: time)
                }
            }
            return completionHandler(tempMessage)
        }
    }
    
    func fetchData(chatId: String, messagesData: [MessagesDataType], completionHandler: @escaping (_ messages: [MessagesDataType]) -> ())
    {
        let messagesRef = Database.database().reference().child("messages").child(chatId)
        let lastMessage = messagesData.first
        var queryRef : DatabaseQuery
        if lastMessage == nil
        {
            queryRef = messagesRef.queryOrdered(byChild: "time").queryLimited(toLast: 20)
        }
        else
        {
            let lastTimeStamp = lastMessage!.time.description
            queryRef = messagesRef.queryOrdered(byChild: "time").queryEnding(atValue: lastTimeStamp).queryLimited(toLast: 20)
        }
        queryRef.observeSingleEvent(of: .value, with: { snap in
            
            var tempMessages = [MessagesDataType]()
            
            for child in snap.children
            {
                if let childSnapshot = child as? DataSnapshot,
                   let dict = childSnapshot.value as? [String:Any],
                   let id = childSnapshot.key as String? ?? "",
                   let userId = dict["myId"] as? String ?? "",
                   let message = dict["message"] as? String ?? "",
                   let time = dict["time"] as? String ?? ""
                {
                    if id != lastMessage?.id
                    {
                        tempMessages.append(MessagesDataType(id: id, userId: userId, message: message, time: time))
                    }
                }
            }
            return(completionHandler(tempMessages))
        })
    }
    
    func addMessage(chatId: String, theirId: String, message: String)
    {
        let db = Database.database().reference()
        
        // save for message List
        db.child("messages").child(chatId).childByAutoId().setValue(["myId" : self.myId, "message": message, "time": Date().rnDate()])
        
        //save to both user's profile
        userObserver.setChatLocation(userId: myId, chatId: chatId, theirId: theirId)
        userObserver.setChatLocation(userId: theirId, chatId: chatId, theirId: myId)
        
    }
}

struct MessagesDataType: Identifiable, Equatable, Hashable
{
    var id: String
    var userId: String
    var message: String
    var time: String
}
