import UIKit

class NewContactViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    var viewModel: NewContactViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createTable()
        setUpViews()
        photoImageView.makeRounded()
        firstNameTextField.becomeFirstResponder()
        phoneTextField.delegate = self
    }
    
    //MARK: - Connect to database and create table
    private func createTable() {
        let database = SQLiteDatabase.sharedInstance
        database.createTable()
    }
    
    //MARK: - Setup the view with the values of the selected contact
    private func setUpViews() {
        if let viewModel = viewModel {
            firstNameTextField.text = viewModel.firstName
            lastNameTextField.text = viewModel.lastName
            phoneTextField.text = viewModel.phoneNumber
            photoImageView.image = viewModel.photo
        }
    }
    
    //MARK: - Save new con tact or update existing contact
    @IBAction func saveButton(_ sender: Any) {
        let id: Int = viewModel == nil ? 0 : viewModel.id!
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let phoneNumber = phoneTextField.text ?? ""
        let uiImage = photoImageView.image ?? #imageLiteral(resourceName: "defualtContactIPhoto")
        guard let photo = uiImage.pngData() else {return}
        
        let contactValues = Contact(id: id, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, photo: photo)
        
        // If viewModel equal to nil, a new contact will be created, otherwise an existing contact will be updated
        if viewModel == nil {
            // Contact created
            createNewContact(contactValues)
        } else {
            // Contact updated
            updateContact(contactValues)
        }
        createNewContact(contactValues)
        SQLiteCommands.presentRow()
    }
    //MARK: - Create new contact
    private func createNewContact(_ contactValues: Contact) {
        let contactAddToTable = SQLiteCommands.insertRow(contactValues)
        // number is unique to each contact
        if contactAddToTable ==  true {
            dismiss(animated: true, completion: nil)
        } else {
            showError("Error", message: "This contact can not be create becasuse this phone is already used")
        }
    }
    
    //MARK: - Update contact
    private func updateContact(_ contactValues: Contact) {
        let contactUpdateInTable = SQLiteCommands.updateRow(contactValues)
        // Phone number is unique to each contact so we check if it already used
        if contactUpdateInTable == true {
            if let cellClicked = navigationController {
                cellClicked.popViewController(animated: true)
            }
        } else {
            showError("Error", message: "This contact cannot be update because this phone is already used")
        }
    }
    
    //MARK: - Cancel button
    @IBAction func cancelButton(_ sender: Any) {
        let addButtonClicked = presentingViewController is UINavigationController
        // If the user clicked to add button on the previous screen
        if addButtonClicked {
            // Dismiss back to the previous screen with animation
            dismiss(animated: true, completion: nil)
        }
        // If the user clicked on a cell on the previous screen
        else if let cellClicked = navigationController {
            cellClicked.popViewController(animated: true)
        } else {
            print("The ContactScreenTableViewController is not inside the navigation controller")
        }
    }
    
    
}

extension NewContactViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: - Image tap gesture
    @IBAction func addImageToPhtoLibrary(_ sender: UITapGestureRecognizer) {
        // let user pick image
        let imagePickerController = UIImagePickerController()
        
        //allow to pick photo
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        photoImageView.image = selectedImage
        
        dismiss(animated: true, completion: nil)
    }
}

extension NewContactViewController: UITextFieldDelegate {
    //MARK: - Phone number valid
    private func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {return false}
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = format(with: "(XX) XX-XXX-XXXX", phone: newString)
        return false
    }
}
