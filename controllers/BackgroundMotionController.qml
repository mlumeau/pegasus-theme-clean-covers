import QtQuick 2.15
import "../js/ThemeHelpers.js" as ThemeHelpers

Item {
    id: root

    property var stage
    property bool enabled: true

    property real startScale: 1.02
    property real endScale: 1.09
    property real startX: 0
    property real endX: 0
    property real startY: 0
    property real endY: 0

    function configure() {
        var zoomIn = Math.random() < 0.5
        var nearScale = ThemeHelpers.randRange(1.02, 1.06)
        var farScale = ThemeHelpers.randRange(1.10, 1.15)

        startScale = zoomIn ? nearScale : farScale
        endScale = zoomIn ? farScale : nearScale

        startX = ThemeHelpers.randRange(-30, 30)
        endX = ThemeHelpers.randDifferent(startX, -42, 42, 10)
        startY = ThemeHelpers.randRange(-20, 20)
        endY = ThemeHelpers.randDifferent(startY, -28, 28, 8)

        applyToStage()
    }

    function applyToStage() {
        if (!stage)
            return

        stage.motionItem.scale = startScale
        stage.translateTransform.x = startX
        stage.translateTransform.y = startY

        stage.zoomAnimation.from = startScale
        stage.zoomAnimation.to = endScale

        stage.driftXAnimation.from = startX
        stage.driftXAnimation.to = endX

        stage.driftYAnimation.from = startY
        stage.driftYAnimation.to = endY
    }

    function restart() {
        configure()
        if (enabled)
            start()
    }

    function start() {
        if (!stage)
            return
        stage.zoomAnimation.restart()
        stage.driftXAnimation.restart()
        stage.driftYAnimation.restart()
    }

    function stop() {
        if (!stage)
            return
        stage.zoomAnimation.stop()
        stage.driftXAnimation.stop()
        stage.driftYAnimation.stop()
    }
}
