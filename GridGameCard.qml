import QtQuick 2.15
import QtGraphicalEffects 1.15

Item {
    id: rootItem
    property var gameObj
    property string posterSource: ""
    property bool selected: false
    property real cardRadius: 12
    property color cardBaseColor: "#161616"
    property color fallbackBackgroundColor: "#2a2d32"
    property color placeholderTextColor: "#f0f0f0"
    property color inactiveTextColor: "#d0d0d0"
    property string condensedFontFamily: ""
    property string sansFontFamily: ""
    property real posterTitlePixelSize: 24
    property real labelPixelSize: 16
    property alias coverVisual: cardWrap
    property alias launchVisual: rootItem

    signal clicked()
    signal launchRequested()

    scale: selected ? 1.06 : 0.9
    opacity: selected ? 1.0 : 0.72

    Behavior on scale { NumberAnimation { duration: 120 } }
    Behavior on opacity { NumberAnimation { duration: 120 } }

    Item {
        id: cardWrap
        anchors.horizontalCenter: parent.horizontalCenter
        y: selected ? 3 : 8
        width: parent.width * 0.86
        height: parent.height * 0.86

        DropShadow {
            anchors.fill: gridCard
            source: gridCard
            horizontalOffset: 0
            verticalOffset: selected ? 5 : 3
            radius: selected ? 16 : 10
            samples: 25
            color: selected ? "#42000000" : "#28000000"
        }

        Rectangle {
            id: gridCard
            width: parent.width
            height: parent.height
            radius: cardRadius
            color: cardBaseColor
        }

        Image {
            id: gridCoverSource
            anchors.fill: gridCard
            source: posterSource
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            cache: true
            smooth: true
            visible: false
        }

        OpacityMask {
            anchors.fill: gridCard
            source: gridCoverSource
            visible: posterSource !== ""
            maskSource: Rectangle {
                width: gridCard.width
                height: gridCard.height
                radius: cardRadius
                color: "white"
            }
        }

        DefaultPoster {
            id: defaultPosterContent
            anchors.fill: gridCard
            visible: false
            backgroundColor: fallbackBackgroundColor
            titleText: gameObj ? gameObj.title : ""
            metaText: ""
            condensedFontFamily: condensedFontFamily
            sansFontFamily: sansFontFamily
            titleColor: placeholderTextColor
            titlePixelSize: posterTitlePixelSize
            metaPixelSize: Math.round(labelPixelSize * 0.9)
        }

        OpacityMask {
            anchors.fill: gridCard
            source: defaultPosterContent
            visible: posterSource === ""
            maskSource: Rectangle {
                width: gridCard.width
                height: gridCard.height
                radius: cardRadius
                color: "white"
            }
        }
    }

    Item {
        anchors.top: cardWrap.bottom
        anchors.topMargin: 7
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width * 0.92
        height: gridLabel.height

        DropShadow {
            anchors.fill: gridLabel
            source: gridLabel
            horizontalOffset: 0
            verticalOffset: 2
            radius: 5
            samples: 11
            color: "#38000000"
        }

        Text {
            id: gridLabel
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: gameObj ? gameObj.title : ""
            color: selected ? "white" : inactiveTextColor
            font.family: sansFontFamily
            font.pixelSize: labelPixelSize
            maximumLineCount: 2
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: false
        onClicked: clicked()
        onDoubleClicked: launchRequested()
    }
}
