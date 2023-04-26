import UIKit


class ContactSreenViewController: UITableViewController {
    private var viewModel = ContactScreenViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

       title = "Note"

        viewModel.connectToDatabase()
    }
    //MARK: - Load data from SQLite database
    private func loadData() {
        viewModel.loadDataFromSQLiteDatabase()
    }
    //MARK: - Table view data soucre
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowInsertion(section: section)
       }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // Configure the cell...
        let object = viewModel.cellForRowAt(indexPath: indexPath)
        
        if let contactCell = cell as? ContactTableViewCell {
            contactCell.setCallValuesOf(object)
        }
        return cell
    }
    // Delete cell from table
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let contact = viewModel.cellForRowAt(indexPath: indexPath)
            // Delete contact from database table
            SQLiteCommands.deleteRow(contactId: contact.id)
            // Updated the UI after deleted
            self.loadData()
            self.tableView.reloadData()
        }
    }
    //Passes selected contact from table cell to NewContactViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Pass selected object to the new view controller
        if segue.identifier == "editContact" {
            guard let newContactVC = segue.destination as? NewContactViewController else {return}
            guard let selectedContactCell = sender as? ContactTableViewCell else {return}
            if let indexPath = tableView.indexPath(for: selectedContactCell) {
                let selectedContact = viewModel.cellForRowAt(indexPath: indexPath)
                newContactVC.viewModel = NewContactViewModel(contactValues: selectedContact)
            }
        }
    }

}



