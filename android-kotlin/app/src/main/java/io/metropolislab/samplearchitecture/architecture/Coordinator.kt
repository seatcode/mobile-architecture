package io.metropolislab.samplearchitecture.architecture

import android.app.Activity
import android.app.Application
import android.arch.lifecycle.ViewModel
import android.arch.lifecycle.ViewModelProvider
import android.arch.lifecycle.ViewModelProviders
import android.content.Intent
import android.os.Bundle
import io.metropolislab.samplearchitecture.extensions.weak
import java.lang.ref.WeakReference


abstract class Coordinator : ViewModelProvider.Factory {

    private var parent: WeakReference<Coordinator>? = null
    private var child: Coordinator? = null

    val topActivity: CoordinatedActivity<*>?
        get() {
            foregroundActivity?.get()?.let { return it }
            if (vmBindings.isEmpty()) return null
            return vmBindings.find { it.weakActivity?.get() != null }?.weakActivity?.get()
        }
    private val topOrParentActivity: CoordinatedActivity<*>?
        get() {
            return topActivity ?: parent?.get()?.topActivity
        }
    private var mainActivityLaunched = false
    private var mainActivityCreated = false

    private val vmBindings: MutableList<VMBinding<*, *>> = mutableListOf()
    private var foregroundActivity: WeakReference<CoordinatedActivity<*>>? = null

    fun openMain(app: Application) {
        app.registerActivityLifecycleCallbacks(CoordinatorLifecycleCallbacks(this))
        open()
    }

    abstract fun open()

    fun close() {
        child?.close()
        vmBindings.forEach {
            it.weakActivity?.get()?.finish()
        }
        vmBindings.clear()
        parent?.get()?.onChildClosed(this)
    }

    private fun onChildClosed(coordinator: Coordinator) {
        if (child == coordinator) {
            child = null
        }
    }

    fun openChild(coordinator: Coordinator) {
        coordinator.parent = this.weak()
        child = coordinator
        coordinator.open()
    }

    protected fun <A, V> setMainViewModel(activityClass: Class<A>, viewModel: V) where A : CoordinatedActivity<V>, V : BaseViewModel {
        val binding = VMBinding(activityClass, viewModel)
        vmBindings.add(0, binding)
    }

    fun <A, V> launchActivity(activityClass: Class<A>, viewModel: V) where A : CoordinatedActivity<V>, V : BaseViewModel {
        val binding = VMBinding(activityClass, viewModel)
        vmBindings.add(0, binding)

        val parent = topOrParentActivity ?: return
        val intent = Intent(parent, activityClass)

        parent.startActivity(intent)
    }

    internal fun onActivityDestroyed(activity: Activity): Boolean {
        val childResult = child?.onActivityDestroyed(activity)
        if (childResult != null && childResult) return true

        activity as? CoordinatedActivity<*> ?: return false

        val foundIndex = vmBindings.indexOfFirst { it.weakActivity?.get() == activity }
        if (foundIndex >= 0) {
            vmBindings.removeAt(foundIndex)
            if (vmBindings.isEmpty()) {
                onMainActivityDestroyed()
            }
            return true
        }

        return false
    }

    internal fun onActivityCreated(activity: Activity, bundle: Bundle?): Boolean {
        val childResult = child?.onActivityCreated(activity, bundle)
        if (childResult != null && childResult) return true

        activity as? CoordinatedActivity<*> ?: return false

        val binding = vmBindings.find { it.matchesActivity(activity) } ?: return false
        binding.bindActivity(activity, this)

        if (!mainActivityCreated) {
            mainActivityCreated = true
            onMainActivityCreated()
        }

        return true
    }

    internal fun onActivityStarted(activity: Activity) {
        //QUESTION Why activity is not used?
        if (!mainActivityLaunched) {
            mainActivityLaunched = true
            onMainActivityLaunched()
        }
    }

    open fun onActivityResumed(activity: Activity) {
        activity as? CoordinatedActivity<*> ?: return
        foregroundActivity = activity.weak()
    }

    abstract fun onMainActivityCreated()

    abstract fun onMainActivityLaunched()

    open fun onMainActivityDestroyed() {
        close()
    }


    open fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        child?.onActivityResult(requestCode, resultCode, data)
    }

    open fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        child?.onRequestPermissionsResult(requestCode, permissions, grantResults)
    }

    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        val binding = vmBindings.find { it.matchesViewModel(modelClass) }
                ?: return modelClass.newInstance()
        val viewModel = binding.viewModel ?: return modelClass.newInstance()
        binding.viewModel = null
        return viewModel as T
    }
}

private class VMBinding<V : BaseViewModel, A : CoordinatedActivity<V>> constructor(private val actClass: Class<A>, viewModel: V) {
    private val vmClass: Class<V> = viewModel.javaClass
    var viewModel: V? = viewModel
    var weakActivity: WeakReference<CoordinatedActivity<*>>? = null

    fun matchesActivity(activity: CoordinatedActivity<*>): Boolean {
        return actClass.isAssignableFrom(activity.javaClass)
    }

    fun <T : ViewModel> matchesViewModel(viewModelClass: Class<T>): Boolean {
        return vmClass.isAssignableFrom(viewModelClass) && viewModel != null
    }

    fun bindActivity(activity: CoordinatedActivity<*>, coordinator: Coordinator) {
        val viewModel = ViewModelProviders.of(activity, coordinator).get(vmClass)
        weakActivity = activity.weak()
        activity.injectCoordination(coordinator, viewModel)
    }
}

private class CoordinatorLifecycleCallbacks(mainCoordinator: Coordinator) : Application.ActivityLifecycleCallbacks {

    private var coordinator: WeakReference<Coordinator> = mainCoordinator.weak()


    override fun onActivityPaused(activity: Activity) {
    }

    override fun onActivityResumed(activity: Activity) {
        coordinator.get()?.onActivityResumed(activity)
    }

    override fun onActivityStarted(activity: Activity) {
        coordinator.get()?.onActivityStarted(activity)
    }

    override fun onActivityDestroyed(activity: Activity) {
        coordinator.get()?.onActivityDestroyed(activity)
    }

    override fun onActivitySaveInstanceState(activity: Activity, bundle: Bundle?) {
    }

    override fun onActivityStopped(activity: Activity) {
    }

    override fun onActivityCreated(activity: Activity, bundle: Bundle?) {
        coordinator.get()?.onActivityCreated(activity, bundle)
    }
}