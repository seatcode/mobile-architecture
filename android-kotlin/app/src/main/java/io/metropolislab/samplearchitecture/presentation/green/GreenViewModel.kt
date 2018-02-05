package io.metropolislab.samplearchitecture.presentation.green

import io.metropolislab.samplearchitecture.architecture.BaseViewModel
import java.lang.ref.WeakReference

class GreenViewModel : BaseViewModel() {
    var navigator: WeakReference<GreenNavigator>? = null

    fun onBackPressed() {
        navigator?.get()?.greenDone()
    }
}