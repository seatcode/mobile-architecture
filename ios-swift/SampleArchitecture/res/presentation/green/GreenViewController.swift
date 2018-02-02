//
//  GreenViewController.swift
//  SampleArchitecture
//
//  Created by Eli Kohen on 02/02/2018.
//  Copyright © 2018 Metropolis:Lab. All rights reserved.
//

import Foundation
import UIKit

class GreenViewController: BaseViewController<GreenViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.green
        
        let finishBtn = UIBarButtonItem(title: "Finished", style: .done, target: self, action: #selector(finishButtonPressed))
        navigationItem.rightBarButtonItem = finishBtn
    }
    
    @objc private func finishButtonPressed() {
        viewModel.finishButtonPressed()
    }
}
