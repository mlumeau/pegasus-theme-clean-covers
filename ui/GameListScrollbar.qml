import QtQuick 2.15

Item {
    property bool vertical: false
    property real normalizedPosition: 0.0
    property real thumbRatio: 0.3
    property real minThumbSize: 28
    property color trackColor: "#12ffffff"
    property color thumbColor: "#78ffffff"

    Rectangle {
        anchors.fill: parent
        radius: vertical ? width / 2 : height / 2
        color: trackColor
    }

    Rectangle {
        id: thumb
        readonly property real clampedRatio: Math.max(0, Math.min(1, thumbRatio))
        readonly property real clampedPosition: Math.max(0, Math.min(1, normalizedPosition))
        readonly property real thumbLength: vertical
            ? Math.min(parent.height, Math.max(minThumbSize, clampedRatio * parent.height))
            : Math.min(parent.width, Math.max(minThumbSize, clampedRatio * parent.width))

        x: vertical ? 0 : clampedPosition * Math.max(0, parent.width - thumbLength)
        y: vertical ? clampedPosition * Math.max(0, parent.height - thumbLength) : 0
        width: vertical ? parent.width : thumbLength
        height: vertical ? thumbLength : parent.height
        radius: vertical ? width / 2 : height / 2
        color: thumbColor

        Behavior on x {
            enabled: !vertical
            NumberAnimation {
                duration: 140
                easing.type: Easing.OutCubic
            }
        }

        Behavior on y {
            enabled: vertical
            NumberAnimation {
                duration: 140
                easing.type: Easing.OutCubic
            }
        }
    }
}
