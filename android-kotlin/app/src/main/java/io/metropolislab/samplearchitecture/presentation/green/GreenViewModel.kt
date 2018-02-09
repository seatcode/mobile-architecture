package io.metropolislab.samplearchitecture.presentation.green

import io.metropolislab.samplearchitecture.architecture.BaseViewModel
import java.lang.ref.WeakReference

class GreenViewModel(val navigator: WeakReference<GreenNavigator>) : BaseViewModel() {

    fun onBackPressed() {
        navigator.get()?.greenDone()
    }
}