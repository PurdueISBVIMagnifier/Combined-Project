import AVFoundation
import UIKit
import WebKit

class FullScreenController: UIViewController, QRCodeReaderViewControllerDelegate {
   
    //VAR INITIALIZATIONS
    var screenShot: UIImage? //Screenshot from the screenshot button
    var urlString: String? = "" //String for the URL that is sent to the select device controller
    
  @IBOutlet weak var previewView: QRCodeReaderView! {
    didSet {
      previewView.setupComponents(showCancelButton: false, showSwitchCameraButton: false, showTorchButton: false, showOverlayView: true, reader: reader)
    }
  }
  lazy var reader: QRCodeReader = QRCodeReader()
  lazy var readerVC: QRCodeReaderViewController = {
    let builder = QRCodeReaderViewControllerBuilder {
      $0.reader          = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
      $0.showTorchButton = true
      
      $0.reader.stopScanningWhenCodeIsFound = false
    }
    
    return QRCodeReaderViewController(builder: builder)
  }()

  // MARK: - Actions

    
    private func checkScanPermissions() -> Bool {
    do {
      return try QRCodeReader.supportsMetadataObjectTypes()
    } catch let error as NSError {
      let alert: UIAlertController

      switch error.code {
      case -11852:
        alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
          DispatchQueue.main.async {
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
            }
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
      default:
        alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      }

      present(alert, animated: true, completion: nil)

      return false
    }
  }

    
    @IBOutlet weak var scannedWeb: WKWebView!
    @IBAction func scanInModalAction(_ sender: AnyObject) {
    guard checkScanPermissions() else { return }

    readerVC.modalPresentationStyle = .formSheet
    readerVC.delegate               = self

    readerVC.completionBlock = { (result: QRCodeReaderResult?) in
      if let result = result {
        print("Completion with result: \(result.value) of type \(result.metadataType)")
        self.GoButton(result: result.value)
      }
    }
    present(readerVC, animated: true, completion: nil)
  }
    
    @IBOutlet weak var wkScanned: WKWebView!
    
     private func GoButton(result: String) {
        //let url = NSURL (string: result)
        urlString = result
        print(result)
        
        wkScanned.loadHTMLString("""
            <html>
                <head>
                    <title>EPICS MAGNIFIER</title>
                </head>
                <body>
                    <img src= \(result)>
                </body>
            </html>
            """, baseURL: nil)
        
        //print()
        //Makes http Request
        //let request = NSURLRequest(url: url! as URL)
        //Loads http request into webView on application
        //wkScanned.load(request as URLRequest)
    }
    
  @IBAction func scanInPreviewAction(_ sender: Any) {
    guard checkScanPermissions(), !reader.isRunning else { return }

    reader.didFindCode = { result in
      print("Completion with result: \(result.value) of type \(result.metadataType)")
    }

    reader.startScanning()
  }

  // MARK: - QRCodeReader Delegate Methods

    @IBOutlet weak var websitescanned: UITextField!
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
    reader.stopScanning()

    dismiss(animated: true) {
      let alert = UIAlertController(
        title: "QRCodeReader",
        message: String (format:"%@ (of type %@)", result.value, result.metadataType),
        preferredStyle: .alert
      )
      alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

        //self?.present(alert, animated: true, completion: nil)
        //self?.websitescanned.text=result.value
        
    }
  }

  func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
    print("Switching capturing to: \(newCaptureDevice.device.localizedName)")
  }

  func readerDidCancel(_ reader: QRCodeReaderViewController) {
    reader.stopScanning()

    dismiss(animated: true, completion: nil)
  }
    
    
    
    
 //-------------------------------------------------------
    
    
    
    //IB INITIALIZATIONS
    @IBOutlet weak var menuButton: UIButton!
    
    //SCEEN SHOT FUNCTIONALITY
    @IBAction func takeScreenshot(_ sender: Any) {
        captureScreenshot()
    }
    
    func captureScreenshot() {
        showScreenshotEffect()
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        
        // Creates UIImage of same size as view
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        //Save screen shot to photos
        screenShot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(screenShot!, nil, nil, nil)
    }
    
    //Animation for Screen Shot
    func showScreenshotEffect() {
        let snapshotView = UIView()
        snapshotView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(snapshotView)
        
        let constraints:[NSLayoutConstraint] =
            [
                snapshotView.topAnchor.constraint(equalTo: view.topAnchor),
                snapshotView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                snapshotView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                snapshotView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ]
        
        NSLayoutConstraint.activate(constraints)
        
        snapshotView.backgroundColor = UIColor.white
        
        UIView.animate(withDuration: 0.6, animations: {
                snapshotView.alpha = 0
        }) { _ in
            snapshotView.removeFromSuperview()
        }
    }
    
    
    
    //PASSES THE SCREENSHOT TO THE OTHER VIEW CONTROLLER
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "screenShotToSV" {
            let layer = UIApplication.shared.keyWindow!.layer
            let scale = UIScreen.main.scale
            
            //Creates UIImage of same size as view
            UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
            layer.render(in: UIGraphicsGetCurrentContext()!)
            
            //Capture Shot
            screenShot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let destinationVC = segue.destination as! SplitController
            destinationVC.sSImage = screenShot
            destinationVC.urlText = urlString!
        }
        
        if segue.identifier == "vcToMenu" {
            let destinationVC = segue.destination as! MenuController
            destinationVC.ipText = urlString
        }
        
        
    }
    
    //MENU BUTTON ON FULL SCREEN
    @IBAction func menuButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "vcToMenu", sender: self)
    }
}
