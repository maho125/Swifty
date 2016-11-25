//
//  ViewController.swift
//  LocalNotification
//
//  Created by Tomas Mahrik on 25/11/2016.
//  Copyright © 2016 Tomas Mahrik. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    //notification main title
    @IBOutlet weak var mainTitle: UITextField!
    //notification subtitle
    @IBOutlet weak var subtitle: UITextField!
    //notification body text
    @IBOutlet weak var body: UITextView!
    
    //stepper
    @IBOutlet weak var intStepper: UIStepper!
    @IBAction func intStepperValueChanged(_ sender: UIStepper) {
        
        //set time interval between 1-20 seconds
        self.time.text = Int((sender as UIStepper).value).description
    }
    
    //notification time interval
    @IBOutlet weak var time: UILabel!
    
    //schedule interval notification
    @IBAction func btnScheduleIntNotification(_ sender: Any) {
        self.scheduleItervalNotification()
    }
    
    var tapGestureRecognizer:UITapGestureRecognizer!
    var alert:UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tap gesture recognizer
        tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.addTarget(self, action: #selector(self.handleTap(recognizer:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        //stepper
        intStepper.wraps = true
        intStepper.autorepeat = true
        intStepper.minimumValue = 1
        intStepper.maximumValue = 20
        
        //step
        time.text = Int(intStepper.value).description
        
    }
    
    //schedule interval notification
    func scheduleItervalNotification(){
        
        //check if all required fields are filled
        if body.text.isEmpty || mainTitle.text!.isEmpty || subtitle.text!.isEmpty {
            showAlert(title: nil, message: "You have to fill all fields.")
            return
        }

        //create interval trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(intStepper.value), repeats: false)
        
        //create notification content
        let content = UNMutableNotificationContent()
        content.title = mainTitle.text!
        content.subtitle = subtitle.text!
        content.body = body.text
        content.sound = UNNotificationSound.default()
        
        //create request
        let request = UNNotificationRequest(identifier: "interNotification" + Int(intStepper.value).description, content: content, trigger: trigger)
        
        //schedule notification
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                self.showAlert(title: nil, message:"Notification iOS 10: " + error.localizedDescription)
            }else{
                self.showAlert(title: nil, message:"Notification was successfully scheduled.")
            }
        }
        
    }
    
    //show alert
    func showAlert(title: String?, message: String?){
        
        alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        //add close action
        let closeAction = UIAlertAction(title: "Close", style: .cancel) { (action) in
            self.mainTitle.text = ""
            self.subtitle.text = ""
            self.body.text = ""
            self.intStepper.value = 1.0
            self.time.text = Int(self.intStepper.value).description
        }
        alert.addAction(closeAction)
        
        //present alert
        present(alert, animated: true, completion: nil)
    }
    
    //handle tap gestures
    func handleTap(recognizer:UITapGestureRecognizer){
        
        //on tap outside form fields will hide keyboard
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

