import QtQuick 2.15
import QtGraphicalEffects 1.15

Column {
    property string titleValue: ""
    property string secondaryValue: ""
    property string metaValue: ""
    property color titleColor: "white"
    property color secondaryColor: "#d8d8d8"
    property color metaColor: "#92ffffff"
    property string condensedFontFamily: ""
    property string sansFontFamily: ""
    property real rootHeight: 1080

    spacing: 0

    Item {
        width: parent.width * 0.74
        height: titleItem.height

        DropShadow {
            anchors.fill: titleItem
            source: titleItem
            horizontalOffset: 0
            verticalOffset: 2
            radius: 8
            samples: 17
            color: "#68000000"
        }

        Text {
            id: titleItem
            text: parent.parent.titleValue
            color: parent.parent.titleColor
            font.family: parent.parent.condensedFontFamily
            font.pixelSize: Math.round(parent.parent.rootHeight * 0.06)
            elide: Text.ElideRight
            width: parent.width
        }
    }

    Item {
        width: parent.width * 0.74
        height: secondaryItem.height

        DropShadow {
            anchors.fill: secondaryItem
            source: secondaryItem
            horizontalOffset: 0
            verticalOffset: 2
            radius: 5
            samples: 11
            color: "#48000000"
        }

        Text {
            id: secondaryItem
            text: parent.parent.secondaryValue
            color: parent.parent.secondaryColor
            font.family: parent.parent.sansFontFamily
            font.pixelSize: Math.round(parent.parent.rootHeight * 0.022)
            elide: Text.ElideRight
            width: parent.width
        }
    }

    Item {
        width: parent.width * 0.9
        height: metaItem.height

        DropShadow {
            anchors.fill: metaItem
            source: metaItem
            horizontalOffset: 0
            verticalOffset: 2
            radius: 5
            samples: 11
            color: "#38000000"
        }

        Text {
            id: metaItem
            text: parent.parent.metaValue
            color: parent.parent.metaColor
            font.family: parent.parent.sansFontFamily
            font.pixelSize: Math.round(parent.parent.rootHeight * 0.018)
            elide: Text.ElideRight
            width: parent.width
            height: Math.round(parent.parent.rootHeight * 0.024)
        }
    }
}
