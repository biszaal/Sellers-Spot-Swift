import Firebase

class MessagesObserver: ObservableObject
{
    @Published var messages = [MessagesDataType]() // Inside of chatbox
    
    var userObserver = UserDataObserver()
    
    func fetchList(chatId: String, completionHandler: @escaping (_ posts: Messages) -> ())
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
    
    //    func fetchData(_ numberOfMessages: Int, firstId: String, secondId: String)
    //    {
    //        let db = Firestore.firestore()
    //        db.collection("messages").order(by: "time").limit(toLast: numberOfMessages).addSnapshotListener
    //            { (snap, err) in
    //
    //            self.messages.removeAll()
    //
    //                if err != nil
    //                {
    //                    print((err?.localizedDescription)!)
    //                    return
    //                }
    //
    //                for i in snap!.documentChanges
    //                {
    //                    if i.type == .added
    //                    {
    //                        let id = i.document.get("userId") as? String ?? ""
    //                        let sendToId = i.document.get("sendToId") as? String ?? ""
    //                        let message = i.document.get("message") as? String ?? ""
    //                        let time = i.document.get("time") as? String ?? ""
    //
    //                        self.messages.append(MessagesDataType(id: id, sendToId: sendToId, message: message, time: time))
    //                    }
    //                }
    //
    //        }
    //    }
    
    func addMessage(chatId: String, userId: String, SendToId: String, message: String)
    {
        let db = Firestore.firestore()
        
        // save for message List
        db.collection("messages").document(chatId).setData(["chatId": chatId, "userOne": userId, "userTwo": SendToId, "recentMessage": message, "time": Date().rnDate()])
        { (err) in
            
            if err != nil
            {
                print((err?.localizedDescription)!)
                return
            }
            print("message sent")
        }
        
        // save for chant box
        db.collection("messages").document(chatId).collection("texts").addDocument(data: ["myId" : userId, "message": message, "time": Date().rnDate()])
        
        //save to both user's profile
        userObserver.setChatLocation(userId: userId, chatId: chatId)
        userObserver.setChatLocation(userId: SendToId, chatId: chatId)
        
    }
}

struct MessagesDataType: Identifiable, Equatable
{
    var id: String
    var sendToId: String
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
