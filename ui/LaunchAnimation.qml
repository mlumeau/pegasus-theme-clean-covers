import QtQuick 2.15
import QtGraphicalEffects 1.15

Item {
    id: launchAnimation
    property bool active: false
    property bool sourceHidden: false
    property var sourceItem: null
    property real coverOpacity: 0.0
    property real coverScale: 1.0

    visible: active

    function placeOverSource(item, hostItem, fallbackWidth, fallbackHeight) {
        sourceItem = item
        if (item) {
            var sourceCenter = item.mapToItem(hostItem, item.width * 0.5, item.height * 0.5)
            var sourceScale = item.scale !== undefined ? item.scale : 1.0
            var scaledWidth = item.width * sourceScale
            var scaledHeight = item.height * sourceScale
            launchCover.x = sourceCenter.x - scaledWidth * 0.5
            launchCover.y = sourceCenter.y - scaledHeight * 0.5
            launchCover.width = scaledWidth
            launchCover.height = scaledHeight
        } else {
            launchCover.x = 0
            launchCover.y = 0
            launchCover.width = fallbackWidth
            launchCover.height = fallbackHeight
        }
    }

    function clearSource() {
        sourceItem = null
    }

    Rectangle {
        anchors.fill: parent
        color: "#5e000000"
        opacity: launchCover.opacity * 0.72
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(0, 0, 0, launchCover.opacity * 0.10) }
            GradientStop { position: 0.45; color: Qt.rgba(0, 0, 0, launchCover.opacity * 0.20) }
            GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, launchCover.opacity * 0.34) }
        }
    }

    Item {
        id: launchCover
        opacity: launchAnimation.coverOpacity
        scale: launchAnimation.coverScale
        transformOrigin: Item.Center

        Behavior on scale {
            NumberAnimation {
                duration: 240
                easing.type: Easing.OutQuint
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 120
                easing.type: Easing.OutQuad
            }
        }

        DropShadow {
            anchors.fill: launchCard
            source: launchCard
            horizontalOffset: 0
            verticalOffset: 12
            radius: 24
            samples: 25
            color: Qt.rgba(0, 0, 0, launchCover.opacity * 0.42)
        }

        ShaderEffectSource {
            id: launchCard
            anchors.fill: parent
            sourceItem: launchAnimation.sourceItem
            live: true
            hideSource: launchAnimation.sourceHidden
            recursive: true
        }
    }
}
