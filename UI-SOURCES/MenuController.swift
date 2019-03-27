import UIKit

class MenuController: UIViewController
{
    //VAR DECLARATIONS
    var ipText: String? //The string that is passed to the select device controller
    @IBOutlet weak var fsButton: UIButton!
    @IBOutlet weak var umButton: UIButton!
    @IBOutlet weak var ssButton: UIButton!
    @IBOutlet weak var rvButton: UIButton!
    override func viewDidLoad() {
        fsButton.titleLabel?.minimumScaleFactor = 0.5;
        fsButton.titleLabel?.adjustsFontSizeToFitWidth = true;
        umButton.titleLabel?.minimumScaleFactor = 0.5;
        umButton.titleLabel?.adjustsFontSizeToFitWidth = true;
        ssButton.titleLabel?.minimumScaleFactor = 0.5;
        ssButton.titleLabel?.adjustsFontSizeToFitWidth = true;
        rvButton.titleLabel?.minimumScaleFactor = 0.5;
        rvButton.titleLabel?.adjustsFontSizeToFitWidth = true;
    }
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

