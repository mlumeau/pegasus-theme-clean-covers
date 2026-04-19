import QtQuick 2.15

Item {
    property color backgroundColor: "#2a2d32"
    property string titleText: ""
    property string metaText: ""
    property string condensedFontFamily: ""
    property string sansFontFamily: ""
    property color titleColor: "#f0f0f0"
    property color metaColor: "#bdbdbd"
    property int titlePixelSize: 24
    property int metaPixelSize: 14

    Rectangle {
        anchors.fill: parent
        color: backgroundColor
    }

    Image {
        anchors.fill: parent
        source: "../assets/theme/default-poster.svg"
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        smooth: true
    }

    Rectangle {
        anchors.fill: parent
        color: "#16000000"
    }

    Text {
        anchors.centerIn: parent
        width: parent.width * 0.8
        text: titleText
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        color: titleColor
        font.family: condensedFontFamily
        font.pixelSize: titlePixelSize
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 18
        text: metaText
        visible: text !== ""
        color: metaColor
        font.family: sansFontFamily
        font.pixelSize: metaPixelSize
    }
}
