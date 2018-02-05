package io.metropolislab.samplearchitecture.presentation.main

import android.os.Bundle
import io.metropolislab.samplearchitecture.R
import io.metropolislab.samplearchitecture.architecture.CoordinatedActivity
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : CoordinatedActivity<MainViewModel>() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        setupUI()
    }

    private fun setupUI() {

        mainTextView.text = viewModel.mainText
        topButton.text = viewModel.yellowButtonText
        bottomButton.text = viewModel.greenButtonText

        topButton.setOnClickListener { viewModel.yellowButtonPressed() }
        bottomButton.setOnClickListener { viewModel.greenButtonPressed() }
    }
}
