//
//  MainViewModel.swift
//  SampleArchitecture
//
//  Created by Eli Kohen on 02/02/2018.
//  Copyright © 2018 Metropolis:Lab. All rights reserved.
//

import Foundation

class MainViewModel: BaseViewModel {
    
    weak var navigator: MainNavigator?
    
    let mainText: String = "This is the main text provided by viewModel"
    
    func firstButtonPressed() {
        navigator?.openYellowProcess()
    }
    
    func secondButtonPressed() {
        navigator?.openGreenProcess()
    }
}
