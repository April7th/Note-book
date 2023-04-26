import Foundation

class ContactScreenViewModel {
    private var contactArray = [Contact]()
    
    func connectToDatabase() {
        _ = SQLiteDatabase.sharedInstance
    }
    
    func loadDataFromSQLiteDatabase() {
        contactArray = SQLiteCommands.presentRow() ?? []
    }
    
    func numberOfRowInsertion(section: Int) -> Int {
        if contactArray.count != 0 {
            return contactArray.count
        }
        return 0
    }
    
    func cellForRowAt(indexPath: IndexPath) -> Contact {
        return contactArray[indexPath.row]
    }
}
