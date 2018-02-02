package io.metropolislab.samplearchitecture.presentation.main

import io.metropolislab.samplearchitecture.architecture.BaseViewModel
import io.metropolislab.samplearchitecture.presentation.coordinator.MainNavigator
import java.lang.ref.WeakReference

class MainViewModel: BaseViewModel() {
    var navigator: WeakReference<MainNavigator>? = null
}