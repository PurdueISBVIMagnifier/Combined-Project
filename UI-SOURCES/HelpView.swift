import UIKit
import WebKit

class HelpView: UIViewController {
    //IB INITIALIZATIONS
    @IBOutlet weak var helpWebView: WKWebView!
    @IBOutlet weak var returnButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //IP STREAM TO SPLIT VIEW
        let path = Bundle.main.path(forResource: "EPICS Magnifier Manual", ofType: "pdf")
        let url = URL(fileURLWithPath: path!)
        let request = URLRequest(url: url)
        helpWebView.load(request)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //RETURN BUTTON PRESSED
    @IBAction func returnButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
