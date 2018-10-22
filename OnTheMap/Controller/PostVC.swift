//
//  PostVC.swift
//  OnTheMap
//
//  Created by Royce Reynolds on 3/27/18.
//  Copyright © 2018 Royce Reynolds. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class PostVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var whatAreYouStudying: UITextView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var linkText: UITextField!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    var userPlacemark: CLPlacemark? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityText.delegate = self
        configureUI()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureUI(_ state: Int = 1){
        
        switch state{
        case 1:
            submitButton.isHidden = true
            linkText.isHidden = true
            findButton.isHidden = false
            cityText.isHidden = false
            topView.isHidden = false
            middleView.isHidden = false
            bottomView.isHidden = false
            whatAreYouStudying.isHidden = false
        case 2:
            submitButton.isHidden = false
            linkText.isHidden = false
            findButton.isHidden = true
            cityText.isHidden = false
            topView.isHidden = false
            middleView.isHidden = true
            bottomView.isHidden = false
            whatAreYouStudying.isHidden = true
        default:
            print("Fuck up!")
        }
        
    }
    
    private func searchLocation(_ address: String){
        
    }
    
    
    @IBAction func cancelPressed(){
        dismiss(animated: true, completion: nil)
    }

    @IBAction func findButtonPressed(_ sender: Any) {
        let findLocation = CLGeocoder()
        
        guard cityText.text != nil else{
            print("No city Text!")
            return
        }
        
        findLocation.geocodeAddressString(cityText.text!) { (placemark, error) in
            if error == nil{
                //print(userPlacemark)
                guard let userPlacemark = placemark else{
                    print("No placemark")
                    return
                }
                
                self.userPlacemark = userPlacemark[0]
                self.configureUI(2)
                self.mapView.showAnnotations([MKPlacemark(placemark: self.userPlacemark!)], animated: true)
                print("success geocoding")
            }
        }
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        
        guard let validURL = URL(string: linkText.text!) else{
            print("invalid url")
            return
        }
        
        ParseClient.sharedInstance().postUserData(validURL, cityText.text, userPlacemark) { (success, error) in
            if success{
                
            }else{
                
            }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
