import UIKit

class MenuController: UIViewController
{
    //VAR DECLARATIONS
    var ipText: String? //The string that is passed to the select device controller
    
    @IBAction func returntoMain(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHelp" {
            _ = segue.destination as! HelpView
        } else if segue.identifier == "toSV" {
            let destinationVC = segue.destination as! SplitController
            destinationVC.urlText = ipText!
        }
    }
}

