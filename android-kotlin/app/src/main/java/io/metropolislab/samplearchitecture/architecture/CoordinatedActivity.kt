package io.metropolislab.samplearchitecture.architecture

import android.arch.lifecycle.ViewModel
import android.content.Intent
import android.support.v7.app.AppCompatActivity
import io.metropolislab.samplearchitecture.extensions.weak
import java.lang.ref.WeakReference


abstract class BaseViewModel : ViewModel() {

    fun onActive(firstTime: Boolean) {}
    fun onInactive() {}
}

abstract class CoordinatedActivity<V : BaseViewModel> : AppCompatActivity() {

    lateinit var viewModel: V
    private var weakCoordinator: WeakReference<Coordinator>? = null
    private val coordinator: Coordinator?
        get() {
            return weakCoordinator?.get()
        }

    private var firstActive = true


    fun injectCoordination(coordinator: Coordinator, viewModel: BaseViewModel): Boolean {
        this.weakCoordinator = coordinator.weak()

        val concreteVM = viewModel as? V ?: return false
        this.viewModel = concreteVM
        return true
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        coordinator?.onActivityResult(requestCode, resultCode, data)
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        coordinator?.onRequestPermissionsResult(requestCode, permissions, grantResults)
    }

    override fun onResume() {
        super.onResume()
        viewModel.onActive(firstActive)
        firstActive = false
    }

    override fun onPause() {
        super.onPause()
        viewModel.onInactive()
    }
}
