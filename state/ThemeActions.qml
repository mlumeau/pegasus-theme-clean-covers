import QtQuick 2.15
import "../js/ThemeHelpers.js" as ThemeHelpers
import "../js/ThemeOptions.js" as ThemeOptions
import "../js/ThemeSort.js" as ThemeSort

QtObject {
    id: root

    property var state
    property var browser
    property var audio
    property var launchController
    property var motionController
    property var memory

    function saveSettings() {
        state.save(memory)
    }

    function currentIndex() {
        return browser.currentIndex
    }

    function currentGame() {
        return browser.currentGame
    }

    function setCurrentIndex(index) {
        if (browser.setCurrentIndex(index))
            audio.playNav()
    }

    function cycleSort(step) {
        var next = ThemeSort.nextVariant(state.sortMode, state.sortAscending, step)
        state.sortMode = next.mode
        state.sortAscending = next.ascending
        setCurrentIndex(0)
        audio.playSort()
        saveSettings()
    }

    function cycleLayout(step) {
        var oldIndex = currentIndex()
        state.layoutMode = (state.layoutMode + step + ThemeOptions.layoutNames.length) % ThemeOptions.layoutNames.length
        browser.setCurrentIndex(oldIndex)
        audio.playLayout()
        saveSettings()
    }

    function cycleFallbackColor(step) {
        state.bgFallbackColor = ThemeOptions.nextFallbackColor(state.bgFallbackColor, state.fallbackColors, step)
        audio.playAdjust()
        saveSettings()
    }

    function adjustBlur(step) {
        var prev = state.bgBlur
        state.bgBlur = ThemeHelpers.clamp(state.bgBlur + step, 0, 48)
        if (state.bgBlur !== prev) {
            audio.playAdjust()
            saveSettings()
        }
    }

    function adjustDark(step) {
        var prev = state.bgDark
        state.bgDark = ThemeHelpers.clamp(state.bgDark + step, 0, 0.85)
        if (state.bgDark !== prev) {
            audio.playAdjust()
            saveSettings()
        }
    }

    function toggleMotion() {
        state.bgMotionEnabled = !state.bgMotionEnabled
        audio.playAdjust()
        if (state.bgMotionEnabled)
            motionController.restart()
        else
            motionController.stop()
        saveSettings()
    }

    function toggleHints() {
        state.showHints = !state.showHints
        audio.playAdjust()
        saveSettings()
    }

    function toggleGameListScrollbar() {
        state.gameListScrollbarEnabled = !state.gameListScrollbarEnabled
        audio.playAdjust()
        saveSettings()
    }

    function toggleSound() {
        state.soundEnabled = !state.soundEnabled
        saveSettings()
    }

    function launchCurrent() {
        var game = browser.currentGame
        var sourceItem = browser.currentLaunchVisual
        if (!game || launchController.blocked || !state.acceptReady)
            return

        state.acceptReady = false
        audio.playLaunch()
        saveSettings()
        launchController.startLaunch(game, sourceItem, browser.currentLaunchFallbackWidth, browser.currentLaunchFallbackHeight)
    }

    function moveSelection(dx, dy, optionsOpen) {
        if (optionsOpen)
            return
        if (browser.moveSelection(dx, dy))
            audio.playNav()
    }
}
