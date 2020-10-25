import Firebase

class MessagesObserver: ObservableObject
{
    var dateFormatter = DateFormatter()
    
    @Published var messages = [MessagesDataType]() // Inside of chatbox
    @Published var messageList = [Messages]()   // Outside of chatbox
    
    func fetchList()
    {
        let db = Firestore.firestore()
        db.collection("messages").order(by: "time").addSnapshotListener
            { (snap, err) in
            
            self.messages.removeAll()
                
                if err != nil
                {
                    print((err?.localizedDescription)!)
                    return
                }
                
                for i in snap!.documentChanges
                {
                    if i.type == .added
                    {
                        let id = i.document.get("chatId") as? String ?? ""
                        let userOne = i.document.get("userOne") as? String ?? ""
                        let userTwo = i.document.get("userTwo") as? String ?? ""
                        let message = i.document.get("recentMessage") as? String ?? ""
                        let date = i.document.get("time") as? String ?? ""
                        
                        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                        let time = self.dateFormatter.date(from: date) ?? Date()
                        
                        self.messageList.append(Messages(id: UUID().uuidString, userOne: userOne, userTwo: userTwo, message: message, time: time))
                    }
                }
            
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
        
        db.collection("messages").document(chatId).setData(["chatId": chatId, "userOne": userId, "userTwo": SendToId, "recentMessage": message, "time": Date().description])
        { (err) in
            
            if err != nil
            {
                print((err?.localizedDescription)!)
                return
            }
            print("message sent")
        }
        
        db.collection("messages").document(chatId).collection("texts").addDocument(data: ["myId" : userId, "message": message, "time": Date().description])
    }
}

struct MessagesDataType: Identifiable, Equatable
{
    var id: String
    var sendToId: String
    var message: String
    var time: String
}
