import QtQuick 2.15
import QtGraphicalEffects 1.15

Item {
    property var hintItems: []
    property color panelColor: "#4a000000"
    property color borderColor: "#18ffffff"
    property color textColor: "#cfcfcf"
    property string fontFamily: ""
    property real textPixelSize: 16
    property real iconPixelSize: 18
    property real extraWidth: 40

    implicitWidth: hintsRow.implicitWidth + extraWidth
    implicitHeight: 42

    DropShadow {
        anchors.fill: hintsPanel
        source: hintsPanel
        horizontalOffset: 0
        verticalOffset: 3
        radius: 10
        samples: 21
        color: "#28000000"
    }

    Rectangle {
        id: hintsPanel
        anchors.fill: parent
        radius: 8
        color: panelColor
        border.width: 1
        border.color: borderColor

        Row {
            id: hintsRow
            anchors.centerIn: parent
            spacing: 30

            Repeater {
                model: hintItems

                delegate: Row {
                    property var iconList: modelData.icons ? modelData.icons : (modelData.icon !== "" ? [modelData.icon] : [])
                    spacing: 12

                    Row {
                        spacing: 5

                        Repeater {
                            model: iconList

                            delegate: Row {
                                spacing: 4

                                Image {
                                    source: modelData
                                    width: iconPixelSize
                                    height: width
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                    asynchronous: true
                                }

                                Text {
                                    visible: index < iconList.length - 1
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "/"
                                    color: textColor
                                    font.family: fontFamily
                                    font.pixelSize: Math.round(textPixelSize * 0.94)
                                }
                            }
                        }
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: modelData.label
                        color: textColor
                        font.family: fontFamily
                        font.pixelSize: textPixelSize
                    }
                }
            }
        }
    }
}
