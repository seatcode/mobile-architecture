package io.metropolislab.samplearchitecture.presentation.main

import android.os.Bundle
import io.metropolislab.samplearchitecture.R
import io.metropolislab.samplearchitecture.architecture.CoordinatedActivity

class MainActivity : CoordinatedActivity<MainViewModel>() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
    }
}
