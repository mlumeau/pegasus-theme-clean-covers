import QtQuick 2.15
import QtGraphicalEffects 1.15

Item {
    property color overlayColor: "#8a000000"
    property color panelTextPrimary: "white"
    property color panelTextSecondary: "#d8d8d8"
    property color panelTextMuted: "#92ffffff"
    property string condensedFontFamily: ""
    property string sansFontFamily: ""
    property var hintItems: []
    property int currentIndex: 0
    property int rowCount: 0
    property var menuLabelFn
    property var menuValueFn
    property real rootHeight: 1080
    readonly property real outerMargin: Math.max(12, Math.round(rootHeight * 0.018))
    readonly property real rowHeight: Math.round(rootHeight * 0.054)

    function ensureCurrentVisible() {
        var targetY = currentIndex * (rowHeight + optionsColumn.spacing)
        var minY = targetY
        var maxY = targetY + rowHeight - rowsViewport.height

        if (rowsFlick.contentY > minY)
            rowsFlick.contentY = minY
        else if (rowsFlick.contentY < maxY)
            rowsFlick.contentY = Math.max(0, maxY)
    }

    Rectangle {
        anchors.fill: parent
        color: overlayColor
    }

    Item {
        id: panel
        anchors.centerIn: parent
        width: Math.min(Math.round(parent.width - outerMargin * 2), Math.max(420, Math.round(parent.width * 0.42)))
        height: Math.min(Math.round(parent.height - outerMargin * 2), Math.round(parent.height * 0.68))

        Rectangle {
            id: panelShell
            anchors.fill: parent
            radius: 16
            color: "#f0121212"
            border.width: 1
            border.color: "#22ffffff"
        }

        DropShadow {
            anchors.fill: panelShell
            source: panelShell
            horizontalOffset: 0
            verticalOffset: 6
            radius: 16
            samples: 25
            color: "#3a000000"
        }

        Column {
            id: headerColumn
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            anchors.topMargin: 18
            spacing: 10

            Item {
                width: parent.width
                height: titleText.height + modalHintRow.height + 18

                Column {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    spacing: 6

                    Text {
                        id: titleText
                        text: "Options"
                        color: panelTextPrimary
                        font.family: condensedFontFamily
                        font.pixelSize: Math.round(rootHeight * 0.04)
                    }

                    Row {
                        id: modalHintRow
                        spacing: 14

                        Repeater {
                            model: hintItems

                            delegate: Row {
                                property var iconList: modelData.icons ? modelData.icons : (modelData.icon ? [modelData.icon] : [])
                                spacing: 6

                                Row {
                                    spacing: 4

                                    Repeater {
                                        model: iconList

                                        delegate: Row {
                                            spacing: 4

                                            Image {
                                                source: modelData
                                                width: Math.round(rootHeight * 0.022)
                                                height: width
                                                fillMode: Image.PreserveAspectFit
                                                smooth: true
                                                asynchronous: true
                                            }

                                            Text {
                                                visible: index < iconList.length - 1
                                                anchors.verticalCenter: parent.verticalCenter
                                                text: "/"
                                                color: panelTextMuted
                                                font.family: sansFontFamily
                                                font.pixelSize: Math.round(rootHeight * 0.015)
                                            }
                                        }
                                    }
                                }

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: modelData.label
                                    color: panelTextMuted
                                    font.family: sansFontFamily
                                    font.pixelSize: Math.round(rootHeight * 0.016)
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: "#12ffffff"
            }

            Item { width: 1; height: 1 }
        }

        Item {
            id: rowsViewport
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: headerColumn.bottom
            anchors.bottom: footerBar.top
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            anchors.topMargin: 10
            anchors.bottomMargin: 10
            clip: true

            Flickable {
                id: rowsFlick
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.rightMargin: 14
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                contentWidth: width
                contentHeight: optionsColumn.height
                boundsBehavior: Flickable.StopAtBounds
                interactive: contentHeight > height
                flickableDirection: Flickable.VerticalFlick
                clip: true

                Column {
                    id: optionsColumn
                    width: rowsFlick.width
                    spacing: 6

                    Repeater {
                        model: rowCount

                        delegate: Item {
                            width: parent.width
                            height: rowHeight

                            Rectangle {
                                id: optionRow
                                anchors.fill: parent
                                radius: 7
                                color: index === currentIndex ? "#16ffffff" : "transparent"
                                border.width: 1
                                border.color: index === currentIndex ? "#30ffffff" : "transparent"
                            }

                            Item {
                                anchors.fill: optionRow
                                anchors.leftMargin: 12
                                anchors.rightMargin: 12

                                Text {
                                    id: optionSelectorRight
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width * 0.08
                                    horizontalAlignment: Text.AlignRight
                                    text: ">"
                                    color: index === currentIndex ? panelTextPrimary : panelTextMuted
                                    font.family: sansFontFamily
                                    font.pixelSize: Math.round(rootHeight * 0.018)
                                }

                                Text {
                                    id: optionValueText
                                    anchors.right: optionSelectorRight.left
                                    anchors.rightMargin: 10
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width * 0.24
                                    horizontalAlignment: Text.AlignHCenter
                                    text: menuValueFn ? menuValueFn(index) : ""
                                    color: index === currentIndex ? panelTextSecondary : panelTextMuted
                                    font.family: sansFontFamily
                                    font.pixelSize: Math.round(rootHeight * 0.018)
                                    elide: Text.ElideRight
                                }

                                Text {
                                    id: optionSelectorLeft
                                    anchors.right: optionValueText.left
                                    anchors.rightMargin: 10
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width * 0.08
                                    horizontalAlignment: Text.AlignLeft
                                    text: "<"
                                    color: index === currentIndex ? panelTextPrimary : panelTextMuted
                                    font.family: sansFontFamily
                                    font.pixelSize: Math.round(rootHeight * 0.018)
                                }

                                Text {
                                    anchors.left: parent.left
                                    anchors.right: optionSelectorLeft.left
                                    anchors.rightMargin: 12
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: menuLabelFn ? menuLabelFn(index) : ""
                                    color: index === currentIndex ? panelTextPrimary : panelTextSecondary
                                    font.family: sansFontFamily
                                    font.pixelSize: Math.round(rootHeight * 0.019)
                                    elide: Text.ElideRight
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                visible: rowsFlick.contentHeight > rowsFlick.height
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                width: 6
                radius: width / 2
                color: "#14ffffff"
            }

            Rectangle {
                visible: rowsFlick.contentHeight > rowsFlick.height
                anchors.right: parent.right
                y: rowsFlick.visibleArea.yPosition * parent.height
                width: 6
                height: Math.max(28, rowsFlick.visibleArea.heightRatio * parent.height)
                radius: width / 2
                color: "#66ffffff"
            }
        }

        Item {
            id: footerBar
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            anchors.bottomMargin: 14
            height: Math.round(rootHeight * 0.054)

            Item {
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                width: closeButtonContent.width + 28
                height: parent.height

                Rectangle {
                    anchors.fill: parent
                    radius: 7
                    color: "transparent"
                    border.width: 1
                    border.color: "#14ffffff"
                }

                Row {
                    id: closeButtonContent
                    anchors.centerIn: parent
                    spacing: 12

                    Image {
                        source: "assets/controller/face-east.svg"
                        width: Math.round(rootHeight * 0.024)
                        height: width
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        asynchronous: true
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Close"
                        color: panelTextMuted
                        font.family: sansFontFamily
                        font.pixelSize: Math.round(rootHeight * 0.017)
                    }
                }
            }
        }
    }

    onCurrentIndexChanged: ensureCurrentVisible()
    onRowCountChanged: ensureCurrentVisible()

    Component.onCompleted: ensureCurrentVisible()
}
