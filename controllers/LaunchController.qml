import QtQuick 2.15
import "../ui" as UI

Item {
    id: root

    property bool blocked: false
    property bool animating: false
    property var pendingGame: null

    readonly property alias sourceHidden: animationLayer.sourceHidden

    function startLaunch(game, sourceItem, fallbackWidth, fallbackHeight) {
        if (!game)
            return

        blocked = true
        pendingGame = game
        animating = true
        animationLayer.sourceHidden = false
        animationLayer.placeOverSource(sourceItem, animationLayer, fallbackWidth, fallbackHeight)
        animationLayer.coverOpacity = 0.96
        animationLayer.coverScale = 1.0
        animationLayer.coverOpacity = 1.0
        animationLayer.coverScale = 1.12

        cooldownTimer.restart()
        hideSourceDelay.restart()
        coverSettleTimer.restart()
        launchDelayTimer.restart()
        resetTimer.restart()
    }

    function reset() {
        animating = false
        pendingGame = null
        animationLayer.sourceHidden = false
        animationLayer.clearSource()
        animationLayer.coverOpacity = 0.0
        animationLayer.coverScale = 1.0
    }

    Timer {
        id: cooldownTimer
        interval: 900
        repeat: false
        onTriggered: root.blocked = false
    }

    Timer {
        id: launchDelayTimer
        interval: 420
        repeat: false
        onTriggered: {
            if (root.pendingGame)
                root.pendingGame.launch()
        }
    }

    Timer {
        id: hideSourceDelay
        interval: 34
        repeat: false
        onTriggered: animationLayer.sourceHidden = true
    }

    Timer {
        id: coverSettleTimer
        interval: 170
        repeat: false
        onTriggered: {
            animationLayer.coverOpacity = 0.98
            animationLayer.coverScale = 1.03
        }
    }

    Timer {
        id: resetTimer
        interval: 640
        repeat: false
        onTriggered: root.reset()
    }

    UI.LaunchAnimation {
        id: animationLayer
        anchors.fill: parent
        active: root.animating
    }
}
