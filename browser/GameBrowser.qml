import QtQuick 2.15
import QtGraphicalEffects 1.15
import "../js/ThemeSort.js" as ThemeSort
import "../ui" as UI

Item {
    id: root

    property int layoutMode: 1
    property bool showHints: true
    property bool gameListScrollbarEnabled: true
    property var gamesModel
    property string collectionName: "All games"
    property color bgFallbackColor: "#2a2d32"

    property color colorTextPrimary: "white"
    property color colorTextSecondary: "#d8d8d8"
    property color colorTextMuted: "#92ffffff"
    property color colorTextInactive: "#d0d0d0"
    property color colorTextPlaceholder: "#f0f0f0"
    property color colorTextPlaceholderMeta: "#bdbdbd"
    property color colorTextSort: "#92ffffff"
    property color colorTextHints: "#cfcfcf"
    property color colorCardBase: "#161616"
    property color colorPanelHints: "#4a000000"
    property color colorBorderHints: "#18ffffff"
    property var controllerHintItems: []

    property int sortMode: 0
    property bool sortAscending: false

    property string condensedFontFamily: ""
    property string sansFontFamily: ""

    property var coverSourceFn
    property var secondaryTextFn
    property var metaTextFn

    readonly property int currentIndex: layoutMode === 0 ? rowView.currentIndex : gridView.currentIndex
    readonly property var currentGame: layoutMode === 0
        ? (rowView.currentItem ? rowView.currentItem.gameObj : null)
        : (gridView.currentItem ? gridView.currentItem.gameObj : null)
    readonly property var currentLaunchVisual: layoutMode === 0
        ? (rowView.currentItem ? rowView.currentItem.launchVisual : null)
        : (gridView.currentItem ? gridView.currentItem.launchVisual : null)
    readonly property real currentLaunchFallbackWidth: layoutMode === 0 ? rowView.coverW : Math.round(gridView.cellWidth * 0.86)
    readonly property real currentLaunchFallbackHeight: layoutMode === 0 ? rowView.coverH : Math.round(gridView.cellHeight * 0.86)

    signal navigateRequested()
    signal launchRequested()
    signal focusRequested()

    function setCurrentIndex(index) {
        var next = Math.max(0, Math.min(index, Math.max(0, gamesModel ? gamesModel.count - 1 : 0)))
        var previous = currentIndex
        if (layoutMode === 0)
            rowView.currentIndex = next
        else
            gridView.currentIndex = next
        return next !== previous
    }

    function moveSelection(dx, dy) {
        if (layoutMode === 0)
            return setCurrentIndex(currentIndex + dx)

        var cols = Math.max(1, gridView.columns)
        return setCurrentIndex(currentIndex + dx + dy * cols)
    }

    function resetIndexes() {
        rowView.currentIndex = 0
        gridView.currentIndex = 0
    }

    anchors.topMargin: Math.round(parent.width * 0.035)
    anchors.leftMargin: Math.round(parent.width * 0.035)
    anchors.rightMargin: Math.round(parent.width * 0.035)

    Item {
        id: headerBlock
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: Math.max(topBlock.height, sortBadgeWrap.height)

        UI.TopInfoPanel {
            id: topBlock
            width: parent.width
            height: implicitHeight
            titleValue: root.currentGame ? root.currentGame.title : "No games"
            secondaryValue: secondaryTextFn ? secondaryTextFn(root.currentGame) : ""
            metaValue: metaTextFn ? metaTextFn(root.currentGame) : ""
            titleColor: colorTextPrimary
            secondaryColor: colorTextSecondary
            metaColor: colorTextMuted
            condensedFontFamily: root.condensedFontFamily
            sansFontFamily: root.sansFontFamily
            rootHeight: root.height
        }

        UI.SortBadge {
            id: sortBadgeWrap
            anchors.top: parent.top
            anchors.right: parent.right
            width: implicitWidth
            height: implicitHeight
            textColor: colorTextSort
            fontFamily: root.sansFontFamily
            textPixelSize: Math.round(root.height * 0.018)
            prefixText: root.collectionName + "  •"
            valueText: ThemeSort.displayName(sortMode, sortAscending)
            iconSource: ThemeSort.iconSource(sortMode)
            iconScale: ThemeSort.iconScale(sortMode)
        }
    }

    ListView {
        id: rowView
        visible: layoutMode === 0
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: headerBlock.bottom
        anchors.topMargin: root.height * 0.045
        anchors.bottom: bottomBlock.top

        model: gamesModel
        orientation: ListView.Horizontal
        spacing: Math.round(root.width * 0.016)
        clip: false
        snapMode: ListView.SnapToItem
        highlightRangeMode: ListView.StrictlyEnforceRange
        preferredHighlightBegin: width * 0.5 - coverW * 0.5
        preferredHighlightEnd: width * 0.5 - coverW * 0.5
        highlightMoveDuration: 150
        interactive: false
        boundsBehavior: Flickable.StopAtBounds
        currentIndex: 0

        property real coverW: Math.round(root.height * 0.34)
        property real coverH: Math.round(coverW * 1.5)

        delegate: UI.RowGameCard {
            width: rowView.coverW
            height: rowView.coverH
            gameObj: modelData
            posterSource: coverSourceFn ? coverSourceFn(modelData) : ""
            selected: ListView.isCurrentItem
            cardBaseColor: colorCardBase
            fallbackBackgroundColor: bgFallbackColor
            placeholderTextColor: colorTextPlaceholder
            placeholderMetaColor: colorTextPlaceholderMeta
            condensedFontFamily: root.condensedFontFamily
            sansFontFamily: root.sansFontFamily
            titlePixelSize: Math.round(root.height * 0.03)
            metaPixelSize: Math.round(root.height * 0.018)

            onClicked: {
                if (rowView.currentIndex !== index) {
                    rowView.currentIndex = index
                    root.navigateRequested()
                }
                root.focusRequested()
            }
            onLaunchRequested: root.launchRequested()
        }
    }

    UI.GameListScrollbar {
        visible: layoutMode === 0 && gameListScrollbarEnabled && rowView.contentWidth > rowView.width
        anchors.horizontalCenter: rowView.horizontalCenter
        anchors.top: rowView.bottom
        anchors.topMargin: Math.round(root.height * 0.018)
        width: Math.min(rowView.width * 0.42, Math.round(root.height * 0.40))
        height: 6
        vertical: false
        normalizedPosition: gamesModel && gamesModel.count > 1 ? rowView.currentIndex / Math.max(1, gamesModel.count - 1) : 0
        thumbRatio: Math.max(1, rowView.width / Math.max(1, rowView.coverW + rowView.spacing)) / Math.max(1, gamesModel ? gamesModel.count : 0)
        minThumbSize: 32
    }

    Item {
        id: gridFadeArea
        visible: layoutMode === 1
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: headerBlock.bottom
        anchors.bottom: parent.bottom
        readonly property real fadeInset: root.height * 0.045
        layer.enabled: visible
        layer.effect: OpacityMask {
            maskSource: Item {
                width: gridFadeArea.width
                height: gridFadeArea.height

                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    height: gridFadeArea.fadeInset
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#00ffffff" }
                        GradientStop { position: 1.0; color: "#ffffffff" }
                    }
                }

                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.topMargin: gridFadeArea.fadeInset
                    anchors.bottom: parent.bottom
                    color: "#ffffffff"
                }
            }
        }

        GridView {
            id: gridView
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: gridFadeArea.fadeInset
            anchors.bottom: parent.bottom

            model: gamesModel
            clip: false
            flow: GridView.FlowLeftToRight
            cellWidth: Math.round(root.width * 0.15)
            cellHeight: Math.round(cellWidth * 1.62)
            interactive: false
            boundsBehavior: Flickable.StopAtBounds
            currentIndex: 0

            readonly property int columns: Math.max(1, Math.floor(width / cellWidth))

            delegate: UI.GridGameCard {
                width: gridView.cellWidth
                height: gridView.cellHeight
                gameObj: modelData
                posterSource: coverSourceFn ? coverSourceFn(modelData) : ""
                selected: GridView.isCurrentItem
                cardBaseColor: colorCardBase
                fallbackBackgroundColor: bgFallbackColor
                placeholderTextColor: colorTextPlaceholder
                inactiveTextColor: colorTextInactive
                condensedFontFamily: root.condensedFontFamily
                sansFontFamily: root.sansFontFamily
                posterTitlePixelSize: Math.round(root.height * 0.024)
                labelPixelSize: Math.round(root.height * 0.017)

                onClicked: {
                    if (gridView.currentIndex !== index) {
                        gridView.currentIndex = index
                        root.navigateRequested()
                    }
                    root.focusRequested()
                }
                onLaunchRequested: root.launchRequested()
            }

            highlightRangeMode: GridView.StrictlyEnforceRange
            preferredHighlightBegin: 0
            preferredHighlightEnd: height - Math.round(parent.width * 0.07)
        }

        UI.GameListScrollbar {
            visible: gameListScrollbarEnabled && gridView.contentHeight > gridView.height
            anchors.right: parent.right
            anchors.rightMargin: Math.round(root.width * 0.01)
            anchors.verticalCenter: parent.verticalCenter
            width: 6
            height: Math.min(parent.height * 0.50, Math.round(root.height * 0.40))
            vertical: true
            normalizedPosition: {
                var totalRows = Math.ceil(Math.max(1, gamesModel ? gamesModel.count : 0) / Math.max(1, gridView.columns))
                var currentRow = Math.floor(gridView.currentIndex / Math.max(1, gridView.columns))
                return totalRows > 1 ? currentRow / Math.max(1, totalRows - 1) : 0
            }
            thumbRatio: (Math.max(1, gridView.height / Math.max(1, gridView.cellHeight)) * gridView.columns) / Math.max(1, gamesModel ? gamesModel.count : 0)
            minThumbSize: 28
        }
    }

    Item {
        id: bottomBlock
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Math.round(parent.width * 0.035)
        height: layoutMode === 0 ? (showHints ? root.height * 0.16 : 0) : (showHints ? root.height * 0.055 : 0)
        visible: showHints || layoutMode === 0

        UI.SummaryBlock {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            width: parent.width * 0.62
            visible: layoutMode === 0 && summaryText !== ""
            summaryText: root.currentGame && root.currentGame.summary ? root.currentGame.summary : ""
            textColor: colorTextSecondary
            fontFamily: root.sansFontFamily
            rootHeight: root.height
        }

        UI.HintBar {
            visible: showHints
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            height: root.height * 0.055
            hintItems: controllerHintItems
            extraWidth: Math.round(root.width * 0.04)
            panelColor: colorPanelHints
            borderColor: colorBorderHints
            textColor: colorTextHints
            fontFamily: root.sansFontFamily
            textPixelSize: Math.round(root.height * 0.017)
            iconPixelSize: Math.round(root.height * 0.026)
        }
    }
}
