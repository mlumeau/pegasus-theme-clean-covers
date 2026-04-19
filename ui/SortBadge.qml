import QtQuick 2.15
import QtGraphicalEffects 1.15

Item {
    property color textColor: "#92ffffff"
    property string fontFamily: ""
    property real textPixelSize: 16
    property string prefixText: ""
    property string labelText: "Sorted by:"
    property string valueText: ""
    property string iconSource: ""
    property real iconScale: 1.0

    implicitWidth: badgeRow.implicitWidth
    implicitHeight: badgeRow.implicitHeight

    DropShadow {
        anchors.fill: badgeRow
        source: badgeRow
        horizontalOffset: 0
        verticalOffset: 2
        radius: 5
        samples: 11
        color: "#38000000"
    }

    Row {
        id: badgeRow
        spacing: 16

        Text {
            visible: prefixText !== ""
            text: prefixText
            color: textColor
            font.family: fontFamily
            font.pixelSize: textPixelSize
        }

        Text {
            text: labelText
            color: textColor
            font.family: fontFamily
            font.pixelSize: textPixelSize
        }

        Row {
            spacing: 9

            Item {
                anchors.verticalCenter: parent.verticalCenter
                width: Math.round(textPixelSize * 1.16)
                height: width

                Image {
                    anchors.centerIn: parent
                    source: iconSource
                    width: parent.width * iconScale
                    height: width
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    asynchronous: true
                    opacity: 0.82
                }
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: valueText
                color: textColor
                font.family: fontFamily
                font.pixelSize: textPixelSize
            }
        }
    }
}
