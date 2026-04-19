import QtQuick 2.15

QtObject {
    property var state
    property var browser
    property var motionController
    property var launchController
    property var memory

    function initialize() {
        state.load(memory)
        browser.resetIndexes()
        if (state.bgMotionEnabled)
            motionController.restart()
        state.acceptReady = true
        launchController.blocked = false
    }

    function shutdown() {
        state.save(memory)
    }
}
