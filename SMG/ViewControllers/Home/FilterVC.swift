//
//  FilterVC.swift
//  SMG
//
//  Created by Amzad Khan on 28/10/18.
//  Copyright © 2018 Amzad Khan. All rights reserved.
//

import UIKit
import TTRangeSlider
class FilterVC: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var btnFilter: UIButton!

    
    @IBOutlet weak var slider: TTRangeSlider!
    var hander:Constants.CompletionHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.minValue = 0
        slider.maxValue = 300
    }
    @IBAction func didUpdateRange(_ sender: Any) {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    @IBAction func didTapFilter(_ sender: Any) {
        guard let handler = self.hander else {return }
        let min  = Int(self.slider.selectedMinimum)
        let max  = Int(self.slider.selectedMaximum)
        handler(["min":min, "max":max], nil)
       //self.dismiss(animated: true, completion: nil)
    }
    @IBAction func didTapCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
        
            let touchLocation =  touch.location(in: self.view)
            // Check if the touch is inside the obstacle view
            
            if !self.contentView.frame.contains(touchLocation) {
                //Touches not in content view Now we can dismiss controller
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
