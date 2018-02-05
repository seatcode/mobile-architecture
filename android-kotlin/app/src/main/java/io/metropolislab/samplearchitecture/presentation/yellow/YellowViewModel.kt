package io.metropolislab.samplearchitecture.presentation.yellow

import io.metropolislab.samplearchitecture.architecture.BaseViewModel
import java.lang.ref.WeakReference

class YellowViewModel : BaseViewModel() {

    var navigator: WeakReference<YellowNavigator>? = null

    fun onBackPressed() {
        navigator?.get()?.yellowDone()
    }
}