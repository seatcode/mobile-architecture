package io.metropolislab.samplearchitecture.presentation.yellow

import android.os.Bundle
import android.support.design.widget.Snackbar
import android.support.v7.app.AppCompatActivity
import io.metropolislab.samplearchitecture.R
import io.metropolislab.samplearchitecture.architecture.BaseViewModel
import io.metropolislab.samplearchitecture.architecture.CoordinatedActivity

import kotlinx.android.synthetic.main.activity_yellow.*

class YellowActivity : CoordinatedActivity<YellowViewModel>() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_yellow)
        setSupportActionBar(toolbar)

        fab.setOnClickListener { view ->
            Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG)
                    .setAction("Action", null).show()
        }
    }

    override fun onBackPressed() {
        viewModel.onBackPressed()
    }

}
