import UIKit


class ViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var originalImage: UIImageView!
    @IBOutlet weak var imageToFilter: UIImageView!
    @IBOutlet weak var filtersScrollView: UIScrollView!
    @IBOutlet weak var IBAction: UIButton!
    
    var CIFilterNames = ["CIPhotoEffectChrome", "CIPhotoEffectFade", "CIPhotoEffectInstant", "CIPhotoEffectNoir", "CIPhotoEffectProcess", "CIPhotoEffectTonal", "CIPhotoEffectTransfer", "CISepiaTone"]
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func CGSizeMake(_ width: CGFloat, _ height: CGFloat) -> CGSize {
        return CGSize(width: width, height: height)
    }
    
    func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func filterButtonTapped(sender: UIButton) {
        let button = sender as UIButton
        
        imageToFilter.image = button.backgroundImage(for: UIControl.State.normal)
    }
   
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    
    
    func savePicButton(_ sender: Any) {
        // Save the image into camera roll
        UIImageWriteToSavedPhotosAlbum(imageToFilter.image!, nil, nil, nil)
        
        let alert = UIAlertView(title: "Filters",
                                message: "Your image has been saved to Photo Library",
                                delegate: nil,
                                cancelButtonTitle: "OK")
        alert.show()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Variables for setting the Font Buttons
        var xCoord: CGFloat = 5
        let yCoord: CGFloat = 5
        let buttonWidth:CGFloat = 70
        let buttonHeight: CGFloat = 70
        let gapBetweenButtons: CGFloat = 5
        
        //Items Counter
        var itemCount = 0
       
        //Loop for creating
        for i in 0..<CIFilterNames.count {
            itemCount = i
            
            // Button properties
            let filterButton = UIButton(type: .custom)
            filterButton.frame = CGRectMake(xCoord, yCoord, buttonWidth, buttonHeight)
            filterButton.tag = itemCount
            filterButton.showsTouchWhenHighlighted = true
            filterButton.addTarget(self, action: #selector(ViewController.filterButtonTapped(_:)), for: UIControl.Event.TouchUpInside)
            filterButton.layer.cornerRadius = 6
            filterButton.clipsToBounds = true
            
            // Create filters for each button
            let ciContext = CIContext(options: nil)
            let coreImage = CIImage(image: originalImage.image!)
            let filter = CIFilter(name: "\(CIFilterNames[i])" )
            filter!.setDefaults()
            filter!.setValue(coreImage, forKey: kCIInputImageKey)
            let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
            let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
            let imageForButton = UIImage(cgImage: filteredImageRef!);
            
            // Assign filtered image to the button
            filterButton.setBackgroundImage(imageForButton, for: .normal)
            
            // Add Buttons in the Scroll View
            xCoord += buttonWidth + gapBetweenButtons
            filtersScrollView.addSubview(filterButton)
        } // END FOR LOOP
        
        // Resize Scroll View
        filtersScrollView.contentSize = CGSizeMake(buttonWidth * CGFloat(itemCount+2), yCoord)
        
    } // END viewDidload()
 
}








    




