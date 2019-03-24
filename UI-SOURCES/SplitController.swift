import UIKit
import WebKit

class SplitController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate {

    //VAR INITIALIZATIONS
    var sSImage : UIImage?
    var urlText : String?
    
    //IB INITIALIZATIONS
    @IBOutlet weak var splitWebView: WKWebView!
    @IBOutlet weak var splitImageView: UIImageView!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var accessPhotosButton: UIButton!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
 
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return splitImageView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageImageLoad()
    }
    
    fileprivate func updateMinZoomScaleForSize(_ size: CGSize) {
        let widthScale = size.width / splitImageView.bounds.width
        let heightScale = size.height / splitImageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scroll.minimumZoomScale = minScale
        scroll.zoomScale = minScale
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateMinZoomScaleForSize(view.bounds.size)
    }

    func pageImageLoad() {
        if sSImage != nil {
            scroll.delegate = self
            splitImageView.image = sSImage
        }
    
        if(urlText != nil) {
            print(urlText!)
            splitWebView.loadHTMLString("""
                <html>
                    <head>
                        <title>EPICS MAGNIFIER</title>
                    </head>
                    <body>
                        <img src= \(urlText ?? "No URL")>
                    </body>
                </html>
                """, baseURL: nil)
        }
    }
    
    @IBAction func accessPhotosPressed(_ sender: Any) {
        accessPhotosButton.showsTouchWhenHighlighted = true
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        //UNWRAPS THE OPTION UIIMAGE VALUE
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            splitImageView.image = image
            sSImage = image
        } else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //DISMISS CODE
    @IBAction func returnBPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "halfToFull" {
            let destinationVC = segue.destination as! FullImageController
            destinationVC.image = sSImage
        }
    }
    
    
    @IBAction func sendToFull(_ sender: Any) {
        performSegue(withIdentifier: "halfToFull", sender: self)
    }
    
}

