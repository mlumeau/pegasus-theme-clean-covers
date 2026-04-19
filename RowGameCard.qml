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
    property color placeholderMetaColor: "#bdbdbd"
    property string condensedFontFamily: ""
    property string sansFontFamily: ""
    property real titlePixelSize: 24
    property real metaPixelSize: 16
    property alias coverVisual: rowVisual
    property alias launchVisual: rootItem

    signal clicked()
    signal launchRequested()

    scale: selected ? 1.0 : 0.87
    opacity: selected ? 1.0 : 0.68

    Behavior on scale { NumberAnimation { duration: 120 } }
    Behavior on opacity { NumberAnimation { duration: 120 } }

    Item {
        id: rowVisual
        anchors.fill: parent

        DropShadow {
            anchors.fill: rowCard
            source: rowCard
            horizontalOffset: 0
            verticalOffset: selected ? 5 : 3
            radius: selected ? 16 : 10
            samples: 25
            color: selected ? "#42000000" : "#28000000"
        }

        Rectangle {
            id: rowCard
            width: parent.width
            height: parent.height
            radius: cardRadius
            color: cardBaseColor
        }

        Image {
            id: rowCoverSource
            anchors.fill: rowCard
            source: posterSource
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            cache: true
            smooth: true
            visible: false
        }

        OpacityMask {
            anchors.fill: rowCard
            source: rowCoverSource
            visible: posterSource !== ""
            maskSource: Rectangle {
                width: rowCard.width
                height: rowCard.height
                radius: cardRadius
                color: "white"
            }
        }

        DefaultPoster {
            id: defaultPosterContent
            anchors.fill: rowCard
            visible: false
            backgroundColor: fallbackBackgroundColor
            titleText: gameObj ? gameObj.title : ""
            metaText: gameObj && gameObj.releaseYear > 0 ? String(gameObj.releaseYear) : ""
            condensedFontFamily: condensedFontFamily
            sansFontFamily: sansFontFamily
            titleColor: placeholderTextColor
            metaColor: placeholderMetaColor
            titlePixelSize: titlePixelSize
            metaPixelSize: metaPixelSize
        }

        OpacityMask {
            anchors.fill: rowCard
            source: defaultPosterContent
            visible: posterSource === ""
            maskSource: Rectangle {
                width: rowCard.width
                height: rowCard.height
                radius: cardRadius
                color: "white"
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: false
        onClicked: clicked()
        onDoubleClicked: launchRequested()
    }
}
