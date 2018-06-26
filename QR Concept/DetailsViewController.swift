//
//  DetailsViewController.swift
//  QR Concept
//
//  Created by James Lincoln on 28/2/18.
//  Copyright © 2018 CAS Development. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    var QRData: String = ""
    
    @IBOutlet weak var QRDetails: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        QRDetails.text = QRData;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
