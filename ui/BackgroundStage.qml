import QtQuick 2.15
import QtGraphicalEffects 1.15

Item {
    property color fallbackColor: "#141414"
    property string backgroundSource: ""
    readonly property bool hasBackgroundImage: backgroundSource !== ""
    property real blurRadius: 18
    property real darkAmount: 0.35
    property color gradientTop: "#08000000"
    property color gradientMiddle: "#26000000"
    property color gradientBottom: "#68000000"
    readonly property real gradientStop1Position: 0.18
    readonly property real gradientStop2Position: 0.42
    readonly property real gradientStop3Position: 0.68
    readonly property real gradientStop4Position: 0.86
    readonly property color gradientStop1Color: "#10000000"
    readonly property color gradientStop2Color: "#1c000000"
    readonly property color gradientStop3Color: "#32000000"
    readonly property color gradientStop4Color: "#4c000000"
    property real initialScale: 1.02

    property alias motionItem: bgMotion
    property alias translateTransform: bgTranslate
    property alias zoomAnimation: zoomAnim
    property alias driftXAnimation: driftXAnim
    property alias driftYAnimation: driftYAnim

    Rectangle {
        anchors.fill: parent
        color: fallbackColor
    }

    Item {
        id: bgMotionSource
        anchors.fill: parent
        visible: true

        Item {
            id: bgMotion
            anchors.centerIn: parent
            width: parent.width * 1.2
            height: parent.height * 1.2
            scale: initialScale
            transform: Translate {
                id: bgTranslate
                x: 0
                y: 0
            }

            Image {
                anchors.fill: parent
                source: backgroundSource
                visible: hasBackgroundImage
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                cache: true
                smooth: true
            }

            NumberAnimation on scale {
                id: zoomAnim
                duration: 15500
                easing.type: Easing.OutCubic
                running: false
            }

            NumberAnimation {
                id: driftXAnim
                target: bgTranslate
                property: "x"
                duration: 16800
                easing.type: Easing.OutCubic
                running: false
            }

            NumberAnimation {
                id: driftYAnim
                target: bgTranslate
                property: "y"
                duration: 17500
                easing.type: Easing.OutCubic
                running: false
            }
        }
    }

    ShaderEffectSource {
        id: motionTexture
        anchors.fill: parent
        sourceItem: bgMotionSource
        live: true
        hideSource: true
    }

    FastBlur {
        anchors.fill: parent
        source: motionTexture
        visible: hasBackgroundImage
        radius: blurRadius
        transparentBorder: true
    }

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, darkAmount)
    }

    Rectangle {
        anchors.fill: parent
        visible: hasBackgroundImage
        gradient: Gradient {
            GradientStop { position: 0.0; color: gradientTop }
            GradientStop { position: gradientStop1Position; color: gradientStop1Color }
            GradientStop { position: gradientStop2Position; color: gradientMiddle }
            GradientStop { position: gradientStop3Position; color: gradientStop3Color }
            GradientStop { position: gradientStop4Position; color: gradientStop4Color }
            GradientStop { position: 1.0; color: gradientBottom }
        }
    }
}
