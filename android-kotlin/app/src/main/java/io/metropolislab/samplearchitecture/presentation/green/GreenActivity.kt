package io.metropolislab.samplearchitecture.presentation.green

import android.os.Bundle
import io.metropolislab.samplearchitecture.R
import io.metropolislab.samplearchitecture.architecture.CoordinatedActivity

class GreenActivity : CoordinatedActivity<GreenViewModel>() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_green)
    }

    override fun onBackPressed() {
        viewModel.onBackPressed()
    }
}
