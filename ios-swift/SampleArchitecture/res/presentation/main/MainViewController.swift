//
//  MainViewController.swift
//  SampleArchitecture
//
//  Created by Eli Kohen on 02/02/2018.
//  Copyright © 2018 Metropolis:Lab. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController<MainViewModel> {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    init(viewModel: MainViewModel) {
        super.init(viewModel: viewModel, nibName: "MainViewController")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = viewModel.mainText
    }
    
    
    // MARK: - Actions
    
    @IBAction func yellowNavigationPressed(_ sender: Any) {
        viewModel.yellowNavigationPressed()
    }
    
    @IBAction func greenNavigationPressed(_ sender: Any) {
        viewModel.greenNavigationPressed()
    }
}
