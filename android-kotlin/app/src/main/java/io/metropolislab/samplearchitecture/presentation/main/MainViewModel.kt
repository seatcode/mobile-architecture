package io.metropolislab.samplearchitecture.presentation.main

import io.metropolislab.samplearchitecture.architecture.BaseViewModel
import java.lang.ref.WeakReference

class MainViewModel(val navigator: WeakReference<MainNavigator>): BaseViewModel() {

    val mainText = "This is the main text provided by viewModel"

    val yellowButtonText = "Open directly on current Coordinator"
    val greenButtonText = "Open with new Coordinator"

    fun yellowButtonPressed() {
        navigator.get()?.openYellow()
    }

    fun greenButtonPressed() {
        navigator.get()?.openGreen()
    }
}