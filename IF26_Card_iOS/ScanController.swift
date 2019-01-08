//
//  ScanController.swift
//  IF26_Card_iOS
//
//  Created by 季婕 on 12/12/2018.
//  Copyright © 2018 if26. All rights reserved.
//

import UIKit
import AVFoundation
import SQLite

class ScanController: UIViewController,AVCaptureMetadataOutputObjectsDelegate{
    
    @IBOutlet weak var topbar: UIView!
    
    var database: Connection!
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var typename:String = ""
    var codepht:UIImage?
    var typepht:UIImage?
    var codestring:String = ""


    
    override func viewDidLoad() {
        super.viewDidLoad()


        //self.navigationController?.isNavigationBarHidden = true
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()

        // Do any additional setup after loading the view.
        view.bringSubviewToFront(topbar)
    }
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.codepht = self.creat_barCode(content: stringValue)
            self.codestring = stringValue
            found( code: stringValue)
            
        
        //dismiss(animated: true)
       // nib.viewDidAppear(true)
            //self.navigationController?.popToRootViewController(animated: true)
           self.performSegue(withIdentifier: "scanreturn", sender: self)
    }
    
    }
   
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
 
    
    func found(code: String) {
        print(code)
      
        
    }
    
    override var prefersStatusBarHidden: Bool {
            return true
        }
        
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            return .portrait
        }
        
   /* func generateBarCode(message:NSString,width: CGFloat, height: CGFloat) -> UIImage {
        var returnImage:UIImage?
        if (message.length > 0 && width > 0 && height > 0){
          let inputData:NSData? = message.data(using: String.Encoding.utf8.rawValue)! as NSData
           // CICode128BarcodeGenerator
          let filter = CIFilter.init(name: "CICode128BarcodeGenerator")!
          filter.setValue(inputData, forKey: "inputMessage")
          var ciImage = filter.outputImage!
          let scaleX = width/ciImage.extent.size.width
          let scaleY = height/ciImage.extent.size.height
          ciImage = ciImage.transformed(by: CGAffineTransform.init(scaleX: scaleX, y: scaleY))
          returnImage = UIImage.init(ciImage: ciImage)
          }else {
            returnImage = nil;
            }
        return returnImage!
        }
    */
     func creat_barCode(content: String?) -> UIImage? {
        

            // format of the bar code
            let data = content?.data(using: String.Encoding.ascii, allowLossyConversion: false)
            let filter = CIFilter(name: "CICode128BarcodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")
            filter?.setValue(NSNumber(value: 0), forKey: "inputQuietSpace")
            let outputImage = filter?.outputImage
            // let the image of the bar code be in color black and white
            let colorFilter = CIFilter(name: "CIFalseColor")!
            colorFilter.setDefaults()
            colorFilter.setValue(outputImage, forKey: "inputImage")
            colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
            colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1, alpha: 0), forKey: "inputColor1")
            // return the bar code
            let codeImage = UIImage(ciImage: (colorFilter.outputImage!.transformed(by: CGAffineTransform(scaleX: 10, y: 10))))
            return self.resizeImage(image: codeImage, newWidth: 300, newHeight: 100)
        
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat, newHeight: CGFloat) -> UIImage {
        
   //     let scale = newWidth / image.size.width
   //     let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth,height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "scanreturn") {
            let cv = segue.destination as! Cardview
            
                if (self.typename == "Sephora") {
                    self.typepht = UIImage(named:"sephora.png")!}
                else if (self.typename == "Darty"){
                    self.typepht = UIImage(named:"darty.png")!
                }
                else if(self.typename == "Carrefour") {
                    self.typepht = UIImage(named:"carrefour.png")!
                }
                else if(self.typename == "Fnac") {
                    self.typepht = UIImage(named:"fnac.png")!
                }
                
                let typephtdata = self.typepht!.pngData()!
                let codephtdata = self.codepht!.pngData()!
                
                cv.newcodest = self.codestring
                cv.newcodedata = codephtdata
                cv.newtypedata = typephtdata
                cv.newtypename = self.typename
                cv.insertsign = true
            cv.tableExist = true
            
            
            
        }
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
