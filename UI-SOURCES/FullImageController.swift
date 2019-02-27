import UIKit

class FullImageController: UIViewController, UIScrollViewDelegate
{
    //VAR INITIALIZATIONS
    var image : UIImage!
    
    //IB INITIALIZATIONS
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var backbutton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //DOES NOT NEEED OPTIONAL UNWRAPPING, WILL ALWAYS HAVE AN IMAGE
        imageView.image = image
        scroll.delegate = self
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    fileprivate func updateMinZoomScaleForSize(_ size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scroll.minimumZoomScale = minScale
        scroll.zoomScale = minScale
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateMinZoomScaleForSize(view.bounds.size)
    }
    
    
    
    @IBAction func backsent(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    
   
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}

