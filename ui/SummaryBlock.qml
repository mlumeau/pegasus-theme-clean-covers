import QtQuick 2.15
import QtGraphicalEffects 1.15

Item {
    property string summaryText: ""
    property color textColor: "#d8d8d8"
    property string fontFamily: ""
    property real rootHeight: 1080

    visible: summaryText !== ""
    implicitHeight: summaryLabel.height

    DropShadow {
        anchors.fill: summaryLabel
        source: summaryLabel
        horizontalOffset: 0
        verticalOffset: 2
        radius: 5
        samples: 11
        color: "#38000000"
    }

    Text {
        id: summaryLabel
        width: parent.width
        text: parent.summaryText
        wrapMode: Text.WordWrap
        maximumLineCount: 3
        elide: Text.ElideRight
        color: parent.textColor
        font.family: parent.fontFamily
        font.pixelSize: Math.round(parent.rootHeight * 0.02)
    }
}
