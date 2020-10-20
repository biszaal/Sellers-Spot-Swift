import Firebase

class MessagesObserver: ObservableObject
{
    
    @Published var messages = [MessagesDataType]() // Inside of chatbox
    //@Published var messageData = [Messages]()   // Outside of chatbox
    
    func fetchData(_ numberOfMessages: Int, firstId: String, secondId: String)
    {
        let db = Firestore.firestore()
        db.collection("messages").order(by: "time").limit(toLast: numberOfMessages).addSnapshotListener
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
                        let id = i.document.get("userId") as? String ?? ""
                        let sendToId = i.document.get("sendToId") as? String ?? ""
                        let message = i.document.get("message") as? String ?? ""
                        let time = i.document.get("time") as? String ?? ""
                        
                        if(id == firstId && secondId == sendToId) || (firstId == sendToId && secondId == id)
                        {
                            self.messages.append(MessagesDataType(id: id, sendToId: sendToId, message: message, time: time))
                        }
                    }
                }
            
        }
    }
    
    func addMessage(userId: String, SendToId: String, message: String)
    {
        let db = Firestore.firestore()
        
        db.collection("messages").addDocument(data: ["userId" : userId, "sendToId": SendToId, "message": message, "time": rnDate()])
        { (err) in
            
            if err != nil
            {
                print((err?.localizedDescription)!)
                return
            }
            print("message sent")
        }
    }
    
    func rnDate() -> String
    {
        let isoFormatter = DateFormatter()
        isoFormatter.dateFormat = "yyyy.MM.dd.HH.mm.ss.Z"
        
        let date = isoFormatter.string(from: Date())
        return date
    }
}

struct MessagesDataType: Identifiable, Equatable
{
    var id: String
    var sendToId: String
    var message: String
    var time: String
}
