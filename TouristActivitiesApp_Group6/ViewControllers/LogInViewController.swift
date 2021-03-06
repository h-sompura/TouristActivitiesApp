import UIKit

class LogInViewController: UIViewController {

  //MARK: User Defaults
  var defaults: UserDefaults = UserDefaults.standard

  //MARK: Variables
  var usersList: [User] = []  //stores users in a list

  //MARK: Outlets
  @IBOutlet weak var txtFieldEmailAddress: UITextField!
  @IBOutlet weak var txtFieldPassword: UITextField!
  @IBOutlet weak var lblError: UILabel!
  @IBOutlet weak var switchRememberUserLogin: UISwitch!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    print(#function, "Login Screen Loaded!")

    //creating users
    createUsers()

    //clear the error label
    lblError.text = ""
  }

  //MARK: Actions
  @IBAction func loginButtonPressed(_ sender: Any) {
    print(#function, "Login Button Pressed")

    //1. Get user email
    guard let emailFromUI = txtFieldEmailAddress.text?.lowercased(), emailFromUI.isEmpty == false
    else {
      lblError.text = "Please enter a valid email"
      lblError.textColor = UIColor.orange
      //before return, clear the field
      txtFieldEmailAddress.text = ""
      return
    }

    //2. Get password
    guard let passwordFromUI = txtFieldPassword.text?.lowercased(), passwordFromUI.isEmpty == false
    else {
      lblError.text = "Please enter a valid password"
      lblError.textColor = UIColor.orange
      //before return, clear the field
      txtFieldEmailAddress.text = ""
      txtFieldPassword.text = ""
      return
    }

    //3. Check if the user exists in our list
    //3 a. Find if email exists in the list
    let checkIfUserInList = usersList.first { $0.emailAddress == emailFromUI }

    if checkIfUserInList != nil {
      //email exists do stuff
      //3 b. Find if password matches
      if passwordFromUI == checkIfUserInList?.password {
        //password matches
        lblError.text = "Login Successful!"
        lblError.textColor = UIColor.green

        //get remember me switch value
        let isRememberSaved = switchRememberUserLogin.isOn
        self.defaults.set(isRememberSaved, forKey: "KEY_REMEMBER_USER")
        let currentUser = User(email: emailFromUI, password: passwordFromUI)
        do {
          // Create JSON Encoder
          let encoder = JSONEncoder()

          // Encode User
          let data = try encoder.encode(currentUser)

          // Write/Set Data
          self.defaults.set(data, forKey: "KEY_CURRENT_USER")

        } catch {
          print("Unable to Encode User (\(error))")
        }

        //move onto next screen
        // - try to get a reference to the next screen
        guard let nextScreen = storyboard?.instantiateViewController(identifier: "TabBarController")
        else {
          print("Cannot find next screen")
          return
        }
        // - navigate to the next screen
        nextScreen.modalPresentationStyle = .fullScreen  //changing tab controller to full screen here
        self.present(nextScreen, animated: true, completion: nil)

      } else {
        //incorrect password
        lblError.text = "The email/password combination does not match"
        lblError.textColor = UIColor.red
      }

    } else {
      //email does not exist in our list
      lblError.text = "This email does not exist"
      lblError.textColor = UIColor.red
      return
    }

    //4. clear the input fields
    txtFieldEmailAddress.text = ""
    txtFieldPassword.text = ""

  }

  // MARK: Helpers/methods
  private func createUsers() {

    let userOne = User(email: "som", password: "123456")
    let userTwo = User(email: "tao", password: "abcdef")

    //add users to the list
    usersList.append(userOne)
    usersList.append(userTwo)
  }

  override func viewWillAppear(_ animated: Bool) {
    print(#function, "LOGIN SCREEN")

  }

  override func viewDidAppear(_ animated: Bool) {
    print(#function, "LOGIN SCREEN")
    //check user login
    let isUserSavedFromUserDefaults: Bool = self.defaults.bool(forKey: "KEY_REMEMBER_USER")
    print("Is user remebered? \(isUserSavedFromUserDefaults)")
    if isUserSavedFromUserDefaults {
      //move onto next screen
      // - try to get a reference to the next screen
      guard let nextScreen = storyboard?.instantiateViewController(identifier: "TabBarController")
      else {
        print("Cannot find next screen")
        return
      }
      // - navigate to the next screen
      nextScreen.modalPresentationStyle = .fullScreen  //changing tab controller to full screen here

      present(nextScreen, animated: true, completion: nil)
    }
  }
}

