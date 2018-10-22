//
//  MapViewVC.swift
//  OnTheMap
//
//  Created by Royce Reynolds on 3/14/18.
//  Copyright © 2018 Royce Reynolds. All rights reserved.
//

import UIKit
import MapKit

class MapViewVC: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annoId = "annoId"
        let newAnnotation: MKPinAnnotationView
        
        if let dequeueAnno = mapView.dequeueReusableAnnotationView(withIdentifier: annoId) as? MKPinAnnotationView {
            dequeueAnno.annotation = annotation
            newAnnotation = dequeueAnno
        }else{
            let failAnno = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annoId)
            failAnno.canShowCallout = true
            failAnno.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            newAnnotation = failAnno
        }
        
        return newAnnotation
    }
    
    func loadData(){
        ParseClient.sharedInstance().getUserData { (success, error) in
            if success{
                self.loadAnnotations(ParseClient.sharedInstance().studentInformation)
            }
        }
        
    }
    
    func loadAnnotations(_ students: [StudentInformation]){
        var annotations = [MKPointAnnotation]()
        
        //var annotation = MKPointAnnotation()
        
        for student in students{
            let annotation = MKPointAnnotation()
            //print(student.studentLocation)
            annotation.coordinate = student.studentLocation
            //print(annotation.coordinate)
            annotations.append(annotation)
        }
        //print(annotations.count)
        //print(annotations)
        
        DispatchQueue.main.async {
            self.mapView.addAnnotations(annotations)
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
