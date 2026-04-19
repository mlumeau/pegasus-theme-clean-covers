import QtQuick 2.15
import QtGraphicalEffects 1.15
import QtMultimedia 5.15
import SortFilterProxyModel 0.2
import "ThemeHelpers.js" as ThemeHelpers

FocusScope {
    id: root
    focus: true

    readonly property color colorTextPrimary: "white"
    readonly property color colorTextSecondary: "#d8d8d8"
    readonly property color colorTextMuted: "#92ffffff"
    readonly property color colorTextHints: "#cfcfcf"
    readonly property color colorTextInactive: "#d0d0d0"
    readonly property color colorTextPlaceholder: "#f0f0f0"
    readonly property color colorTextPlaceholderMeta: "#bdbdbd"
    readonly property color colorTextSort: "#92ffffff"

    readonly property color colorCardBase: "#161616"
    readonly property color colorCardPlaceholder: "#232323"
    readonly property color colorCardPlaceholderHeader: "#323232"

    readonly property color colorBorderHints: "#18ffffff"
    readonly property color colorBorderModal: "#30ffffff"
    readonly property color colorBorderMenuSelected: "#50ffffff"

    readonly property color colorOverlayBackground: "#8a000000"
    readonly property color colorOverlayGradientTop: "#08000000"
    readonly property color colorOverlayGradientMiddle: "#26000000"
    readonly property color colorOverlayGradientBottom: "#68000000"
    readonly property color colorPanelHints: "#4a000000"
    readonly property color colorPanelFooter: "#16000000"
    readonly property color colorPanelModal: "#ee111111"
    readonly property color colorMenuItemSelected: "#2bffffff"
    readonly property color colorMenuItemIdle: "#12000000"

    property int layoutMode: 1
    property int sortMode: 0
    property bool sortAscending: false
    property real bgBlur: 18
    property real bgDark: 0.35
    property color bgFallbackColor: "#2a2d32"
    property bool bgMotionEnabled: true
    property bool showHints: true
    property bool gameListScrollbarEnabled: true
    property bool optionsOpen: false
    property bool soundEnabled: true

    property bool acceptReady: true
    property bool launchBlocked: false
    property bool launchAnimating: false
    property var pendingLaunchGame: null

    property int optionsIndex: 0

    property real bgStartScale: 1.02
    property real bgEndScale: 1.09
    property real bgStartX: 0
    property real bgEndX: 0
    property real bgStartY: 0
    property real bgEndY: 0

    readonly property var fallbackColors: [
        { name: "Charcoal", value: "#151316" },
        { name: "Slate Blue", value: "#243052" },
        { name: "Graphite", value: "#2a2d32" },
        { name: "Burgundy", value: "#361a22" },
        { name: "Forest", value: "#183025" },
        { name: "Midnight", value: "#141c31" }
    ]

    readonly property var sortNames: ["Last played", "Title", "Release year", "Play count", "Play time"]
    readonly property var sortVariants: [
        { mode: 0, ascending: false },
        { mode: 0, ascending: true },
        { mode: 1, ascending: true },
        { mode: 1, ascending: false },
        { mode: 2, ascending: false },
        { mode: 2, ascending: true },
        { mode: 3, ascending: false },
        { mode: 3, ascending: true },
        { mode: 4, ascending: false },
        { mode: 4, ascending: true }
    ]
    readonly property var layoutNames: ["Row", "Grid"]
    readonly property var controllerHintItems: [
        { icon: "assets/controller/face-south.svg", label: "Launch" },
        { icon: "assets/controller/face-east.svg", label: "Back" },
        { icon: "assets/controller/face-west.svg", label: "Sort" },
        { icon: "assets/controller/face-north.svg", label: "Options" },
        { icons: ["assets/controller/dpad.svg", "assets/controller/left-stick.svg"], label: "Navigate" }
    ]
    readonly property var modalHintItems: [
        { icons: ["assets/controller/dpad.svg", "assets/controller/left-stick.svg"], label: "Move / Adjust" },
        { icon: "assets/controller/face-east.svg", label: "Close" }
    ]

    function clamp(v, a, b) { return ThemeHelpers.clamp(v, a, b) }

    function configureBackgroundMotion() {
        var zoomIn = Math.random() < 0.5
        var nearScale = ThemeHelpers.randRange(1.02, 1.06)
        var farScale = ThemeHelpers.randRange(1.10, 1.15)

        bgStartScale = zoomIn ? nearScale : farScale
        bgEndScale = zoomIn ? farScale : nearScale

        bgStartX = ThemeHelpers.randRange(-30, 30)
        bgEndX = ThemeHelpers.randDifferent(bgStartX, -42, 42, 10)
        bgStartY = ThemeHelpers.randRange(-20, 20)
        bgEndY = ThemeHelpers.randDifferent(bgStartY, -28, 28, 8)

        backgroundStage.motionItem.scale = bgStartScale
        backgroundStage.translateTransform.x = bgStartX
        backgroundStage.translateTransform.y = bgStartY

        backgroundStage.zoomAnimation.from = bgStartScale
        backgroundStage.zoomAnimation.to = bgEndScale

        backgroundStage.driftXAnimation.from = bgStartX
        backgroundStage.driftXAnimation.to = bgEndX

        backgroundStage.driftYAnimation.from = bgStartY
        backgroundStage.driftYAnimation.to = bgEndY
    }

    function restartBackgroundMotion() {
        configureBackgroundMotion()
        if (bgMotionEnabled) {
            backgroundStage.zoomAnimation.restart()
            backgroundStage.driftXAnimation.restart()
            backgroundStage.driftYAnimation.restart()
        }
    }

    function sortIconSource() { return ThemeHelpers.sortIconSource(sortMode) }
    function defaultSortAscendingForMode(mode) { return ThemeHelpers.defaultSortAscendingForMode(mode) }

    function currentSortVariantIndex() {
        for (var i = 0; i < sortVariants.length; ++i) {
            if (sortVariants[i].mode === sortMode && sortVariants[i].ascending === sortAscending)
                return i
        }
        return 0
    }

    function applySortVariant(index) {
        var next = sortVariants[(index + sortVariants.length) % sortVariants.length]
        sortMode = next.mode
        sortAscending = next.ascending
    }

    function sortDisplayName() { return ThemeHelpers.sortDisplayName(sortMode, sortAscending, sortNames) }
    function sortIconScale() { return ThemeHelpers.sortIconScale(sortMode) }
    function fallbackColorName() { return ThemeHelpers.fallbackColorName(bgFallbackColor, fallbackColors) }

    function currentIndex() {
        return layoutMode === 0 ? rowView.currentIndex : gridView.currentIndex
    }

    function currentGame() {
        if (layoutMode === 0)
            return rowView.currentItem ? rowView.currentItem.gameObj : null
            return gridView.currentItem ? gridView.currentItem.gameObj : null
    }

    function sfxPlay(sfx) {
        if (!soundEnabled || !sfx)
            return
            sfx.stop()
            sfx.play()
    }

    function playNav()      { sfxPlay(sfxNav) }
    function playBack()     { sfxPlay(sfxBack) }
    function playSort()     { sfxPlay(sfxSwitchF) }
    function playLayout()   { sfxPlay(sfxSwitchB) }
    function playAdjust()   { sfxPlay(sfxType) }
    function playMenuOpen() { sfxPlay(sfxTab) }
    function playLaunch()   { sfxPlay(sfxGame) }

    function coverSource(game) { return ThemeHelpers.coverSource(game) }
    function bgSource(game) { return ThemeHelpers.bgSource(game) }
    function secondaryText(game) { return ThemeHelpers.secondaryText(game) }
    function metaText(game) { return ThemeHelpers.metaText(game) }

    function setCurrentIndex(i) {
        var next = clamp(i, 0, Math.max(0, sortedGames.count - 1))
        var prev = currentIndex()
        if (layoutMode === 0) rowView.currentIndex = next
            else gridView.currentIndex = next

                if (next !== prev)
                    playNav()
    }

    function saveSettings() {
        api.memory.set("dcg.layoutMode", layoutMode)
        api.memory.set("dcg.sortMode", sortMode)
        api.memory.set("dcg.sortAscending", sortAscending)
        api.memory.set("dcg.bgBlur", bgBlur)
        api.memory.set("dcg.bgDark", bgDark)
        api.memory.set("dcg.bgFallbackColor", bgFallbackColor.toString())
        api.memory.set("dcg.bgMotionEnabled", bgMotionEnabled)
        api.memory.set("dcg.showHints", showHints)
        api.memory.set("dcg.gameListScrollbarEnabled", gameListScrollbarEnabled)
        api.memory.set("dcg.soundEnabled", soundEnabled)
    }

    function loadSettings() {
        layoutMode = api.memory.has("dcg.layoutMode") ? api.memory.get("dcg.layoutMode") : 1
        sortMode = api.memory.has("dcg.sortMode") ? api.memory.get("dcg.sortMode") : 0
        sortAscending = api.memory.has("dcg.sortAscending") ? api.memory.get("dcg.sortAscending") : defaultSortAscendingForMode(sortMode)
        bgBlur = api.memory.has("dcg.bgBlur") ? api.memory.get("dcg.bgBlur") : 18
        bgDark = api.memory.has("dcg.bgDark") ? api.memory.get("dcg.bgDark") : 0.35
        bgFallbackColor = api.memory.has("dcg.bgFallbackColor") ? api.memory.get("dcg.bgFallbackColor") : "#2a2d32"
        bgMotionEnabled = api.memory.has("dcg.bgMotionEnabled") ? api.memory.get("dcg.bgMotionEnabled") : true
        showHints = api.memory.has("dcg.showHints") ? api.memory.get("dcg.showHints") : true
        gameListScrollbarEnabled = api.memory.has("dcg.gameListScrollbarEnabled") ? api.memory.get("dcg.gameListScrollbarEnabled") : true
        soundEnabled = api.memory.has("dcg.soundEnabled") ? api.memory.get("dcg.soundEnabled") : true
    }

    function cycleSort(step) {
        applySortVariant(currentSortVariantIndex() + step)
        setCurrentIndex(0)
        playSort()
        saveSettings()
    }

    function cycleLayout(step) {
        var oldIndex = currentIndex()
        layoutMode = (layoutMode + step + layoutNames.length) % layoutNames.length
        if (layoutMode === 0)
            rowView.currentIndex = clamp(oldIndex, 0, Math.max(0, sortedGames.count - 1))
            else
                gridView.currentIndex = clamp(oldIndex, 0, Math.max(0, sortedGames.count - 1))
                playLayout()
                saveSettings()
    }

    function cycleFallbackColor(step) {
        var current = bgFallbackColor.toString()
        var idx = 0
        for (var i = 0; i < fallbackColors.length; ++i) {
            if (fallbackColors[i].value === current) {
                idx = i
                break
            }
        }
        idx = (idx + step + fallbackColors.length) % fallbackColors.length
        bgFallbackColor = fallbackColors[idx].value
        playAdjust()
        saveSettings()
    }

    function adjustBlur(step) {
        var prev = bgBlur
        bgBlur = clamp(bgBlur + step, 0, 48)
        if (bgBlur !== prev)
            playAdjust()
            saveSettings()
    }

    function adjustDark(step) {
        var prev = bgDark
        bgDark = clamp(bgDark + step, 0, 0.85)
        if (bgDark !== prev)
            playAdjust()
            saveSettings()
    }

    function toggleMotion() {
        bgMotionEnabled = !bgMotionEnabled
        playAdjust()
        if (bgMotionEnabled) {
            restartBackgroundMotion()
        } else {
            backgroundStage.zoomAnimation.stop()
            backgroundStage.driftXAnimation.stop()
            backgroundStage.driftYAnimation.stop()
        }
        saveSettings()
    }

    function toggleHints() {
        showHints = !showHints
        playAdjust()
        saveSettings()
    }

    function toggleGameListScrollbar() {
        gameListScrollbarEnabled = !gameListScrollbarEnabled
        playAdjust()
        saveSettings()
    }

    function toggleSound() {
        soundEnabled = !soundEnabled
        saveSettings()
    }

    function launchCurrent() {
        var game = currentGame()
        var sourceItem = layoutMode === 0
            ? (rowView.currentItem ? rowView.currentItem.launchVisual : null)
            : (gridView.currentItem ? gridView.currentItem.launchVisual : null)
        if (!game || launchBlocked || !acceptReady)
            return

        launchBlocked = true
        acceptReady = false
        launchCooldown.restart()

        playLaunch()
        saveSettings()
        pendingLaunchGame = game
        launchAnimating = true
        launchAnimationLayer.sourceHidden = false
        launchAnimationLayer.placeOverSource(sourceItem, launchAnimationLayer, layoutMode === 0 ? rowView.coverW : Math.round(gridView.cellWidth * 0.86), layoutMode === 0 ? rowView.coverH : Math.round(gridView.cellHeight * 0.86))
        launchAnimationLayer.coverOpacity = 0.96
        launchAnimationLayer.coverScale = 1.0
        launchAnimationLayer.coverOpacity = 1.0
        launchAnimationLayer.coverScale = 1.12
        launchSourceHideDelay.restart()
        launchCoverSettle.restart()
        launchDelay.restart()
        launchAnimationReset.restart()
    }

    function moveSelection(dx, dy) {
        if (optionsOpen)
            return

            if (layoutMode === 0) {
                setCurrentIndex(currentIndex() + dx)
            } else {
                var cols = Math.max(1, gridView.columns)
                var idx = currentIndex() + dx + dy * cols
                setCurrentIndex(idx)
            }
    }

    function openOptions() {
        optionsOpen = true
        optionsIndex = 0
        playMenuOpen()
    }

    function closeOptions() {
        optionsOpen = false
        playBack()
    }

    function optionCount() { return 9 }

    function menuLabel(i) {
        switch (i) {
            case 0: return "Sort"
            case 1: return "Layout"
            case 2: return "Background blur"
            case 3: return "Background dark"
            case 4: return "Default background"
            case 5: return "Background motion"
            case 6: return "Controller hints"
            case 7: return "Game list scrollbar"
            case 8: return "UI sounds"
            default: return ""
        }
    }

    function menuValue(i) {
        switch (i) {
            case 0: return sortDisplayName()
            case 1: return layoutNames[layoutMode]
            case 2: return String(Math.round(bgBlur))
            case 3: return String(Math.round(bgDark * 100)) + "%"
            case 4: return fallbackColorName()
            case 5: return bgMotionEnabled ? "Enabled" : "Disabled"
            case 6: return showHints ? "Enabled" : "Disabled"
            case 7: return gameListScrollbarEnabled ? "Enabled" : "Disabled"
            case 8: return soundEnabled ? "Enabled" : "Disabled"
            default: return ""
        }
    }

    function menuAdjust(step) {
        switch (optionsIndex) {
            case 0: cycleSort(step); break
            case 1: cycleLayout(step); break
            case 2: adjustBlur(step * 2); break
            case 3: adjustDark(step * 0.05); break
            case 4: cycleFallbackColor(step); break
            case 5: if (step !== 0) toggleMotion(); break
            case 6: if (step !== 0) toggleHints(); break
            case 7: if (step !== 0) toggleGameListScrollbar(); break
            case 8: if (step !== 0) toggleSound(); break
        }
    }

    Timer {
        id: launchCooldown
        interval: 900
        repeat: false
        onTriggered: launchBlocked = false
    }

    Timer {
        id: launchDelay
        interval: 420
        repeat: false
        onTriggered: {
            if (pendingLaunchGame)
                pendingLaunchGame.launch()
        }
    }

    Timer {
        id: launchSourceHideDelay
        interval: 34
        repeat: false
        onTriggered: launchAnimationLayer.sourceHidden = true
    }

    Timer {
        id: launchCoverSettle
        interval: 170
        repeat: false
        onTriggered: {
            launchAnimationLayer.coverOpacity = 0.98
            launchAnimationLayer.coverScale = 1.03
        }
    }

    Timer {
        id: launchAnimationReset
        interval: 640
        repeat: false
        onTriggered: {
            launchAnimating = false
            pendingLaunchGame = null
            launchAnimationLayer.sourceHidden = false
            launchAnimationLayer.clearSource()
            launchAnimationLayer.coverOpacity = 0.0
            launchAnimationLayer.coverScale = 1.0
        }
    }

    SoundEffect { id: sfxGame;     source: "assets/audio/launch.wav";   volume: 0.75 }
    SoundEffect { id: sfxBack;     source: "assets/audio/back.wav";     volume: 0.85 }
    SoundEffect { id: sfxNav;      source: "assets/audio/navigate.wav"; volume: 0.55 }
    SoundEffect { id: sfxSwitchB;  source: "assets/audio/layout.wav";   volume: 0.75 }
    SoundEffect { id: sfxSwitchF;  source: "assets/audio/sort.wav";     volume: 0.75 }
    SoundEffect { id: sfxTab;      source: "assets/audio/menu-open.wav"; volume: 0.75 }
    SoundEffect { id: sfxType;     source: "assets/audio/adjust.wav";   volume: 0.70 }

    SortFilterProxyModel {
        id: sortedGames
        sourceModel: api.allGames

        sorters: [
            RoleSorter {
                enabled: root.sortMode === 0
                roleName: "lastPlayed"
                sortOrder: root.sortAscending ? Qt.AscendingOrder : Qt.DescendingOrder
            },
            RoleSorter {
                enabled: root.sortMode === 1
                roleName: "sortBy"
                sortOrder: root.sortAscending ? Qt.AscendingOrder : Qt.DescendingOrder
            },
            RoleSorter {
                enabled: root.sortMode === 2
                roleName: "releaseYear"
                sortOrder: root.sortAscending ? Qt.AscendingOrder : Qt.DescendingOrder
            },
            RoleSorter {
                enabled: root.sortMode === 3
                roleName: "playCount"
                sortOrder: root.sortAscending ? Qt.AscendingOrder : Qt.DescendingOrder
            },
            RoleSorter {
                enabled: root.sortMode === 4
                roleName: "playTime"
                sortOrder: root.sortAscending ? Qt.AscendingOrder : Qt.DescendingOrder
            },
            RoleSorter {
                enabled: root.sortMode !== 1
                roleName: "sortBy"
                sortOrder: Qt.AscendingOrder
            }
        ]
    }

    BackgroundStage {
        id: backgroundStage
        anchors.fill: parent
        fallbackColor: bgFallbackColor
        backgroundSource: bgSource(currentGame())
        blurRadius: bgBlur
        darkAmount: bgDark
        gradientTop: colorOverlayGradientTop
        gradientMiddle: colorOverlayGradientMiddle
        gradientBottom: colorOverlayGradientBottom
        initialScale: bgStartScale
    }

    LaunchAnimation {
        id: launchAnimationLayer
        anchors.fill: parent
        z: 80
        active: launchAnimating
    }

    Item {
        id: chrome
        anchors.fill: parent
        anchors.topMargin: Math.round(parent.width * 0.035)
        anchors.leftMargin: Math.round(parent.width * 0.035)
        anchors.rightMargin: Math.round(parent.width * 0.035)

        Item {
            id: headerBlock
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: Math.max(topBlock.height, sortBadgeWrap.height)

            TopInfoPanel {
                id: topBlock
                width: parent.width
                height: implicitHeight
                titleValue: currentGame() ? currentGame().title : "No games"
                secondaryValue: secondaryText(currentGame())
                metaValue: metaText(currentGame())
                titleColor: colorTextPrimary
                secondaryColor: colorTextSecondary
                metaColor: colorTextMuted
                condensedFontFamily: global.fonts.condensed
                sansFontFamily: global.fonts.sans
                rootHeight: root.height
            }

            SortBadge {
                id: sortBadgeWrap
                anchors.top: parent.top
                anchors.right: parent.right
                width: implicitWidth
                height: implicitHeight
                textColor: colorTextSort
                fontFamily: global.fonts.sans
                textPixelSize: Math.round(root.height * 0.018)
                valueText: sortDisplayName()
                iconSource: sortIconSource()
                iconScale: sortIconScale()
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
            anchors.bottomMargin: 0

            model: sortedGames
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

            onCurrentIndexChanged: if (visible) restartBackgroundMotion()

            delegate: RowGameCard {
                width: rowView.coverW
                height: rowView.coverH
                gameObj: modelData
                posterSource: coverSource(modelData)
                selected: ListView.isCurrentItem
                cardBaseColor: colorCardBase
                fallbackBackgroundColor: bgFallbackColor
                placeholderTextColor: colorTextPlaceholder
                placeholderMetaColor: colorTextPlaceholderMeta
                condensedFontFamily: global.fonts.condensed
                sansFontFamily: global.fonts.sans
                titlePixelSize: Math.round(root.height * 0.03)
                metaPixelSize: Math.round(root.height * 0.018)

                onClicked: {
                    if (rowView.currentIndex !== index) {
                        rowView.currentIndex = index
                        playNav()
                    }
                    root.forceActiveFocus()
                }
                onLaunchRequested: root.launchCurrent()
            }
        }

        GameListScrollbar {
            visible: layoutMode === 0 && gameListScrollbarEnabled && rowView.contentWidth > rowView.width
            anchors.horizontalCenter: rowView.horizontalCenter
            anchors.top: rowView.bottom
            anchors.topMargin: Math.round(root.height * 0.018)
            width: Math.min(rowView.width * 0.42, Math.round(root.height * 0.40))
            height: 6
            vertical: false
            normalizedPosition: sortedGames.count > 1 ? rowView.currentIndex / Math.max(1, sortedGames.count - 1) : 0
            thumbRatio: Math.max(1, rowView.width / Math.max(1, rowView.coverW + rowView.spacing)) / Math.max(1, sortedGames.count)
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

                model: sortedGames
                clip: false
                flow: GridView.FlowLeftToRight
                cellWidth: Math.round(root.width * 0.15)
                cellHeight: Math.round(cellWidth * 1.62)
                interactive: false
                boundsBehavior: Flickable.StopAtBounds
                currentIndex: 0

                readonly property int columns: Math.max(1, Math.floor(width / cellWidth))

                onCurrentIndexChanged: if (visible) restartBackgroundMotion()

                delegate: GridGameCard {
                    width: gridView.cellWidth
                    height: gridView.cellHeight
                    gameObj: modelData
                    posterSource: coverSource(modelData)
                    selected: GridView.isCurrentItem
                    cardBaseColor: colorCardBase
                    fallbackBackgroundColor: bgFallbackColor
                    placeholderTextColor: colorTextPlaceholder
                    inactiveTextColor: colorTextInactive
                    condensedFontFamily: global.fonts.condensed
                    sansFontFamily: global.fonts.sans
                    posterTitlePixelSize: Math.round(root.height * 0.024)
                    labelPixelSize: Math.round(root.height * 0.017)

                    onClicked: {
                        if (gridView.currentIndex !== index) {
                            gridView.currentIndex = index
                            playNav()
                        }
                        root.forceActiveFocus()
                    }
                    onLaunchRequested: root.launchCurrent()
                }

                highlightRangeMode: GridView.StrictlyEnforceRange
                preferredHighlightBegin: 0
                preferredHighlightEnd: height - Math.round(parent.width * 0.07)
            }

            GameListScrollbar {
                visible: gameListScrollbarEnabled && gridView.contentHeight > gridView.height
                anchors.right: parent.right
                anchors.rightMargin: Math.round(root.width * 0.01)
                anchors.verticalCenter: parent.verticalCenter
                width: 6
                height: Math.min(parent.height * 0.50, Math.round(root.height * 0.40))
                vertical: true
                normalizedPosition: {
                    var totalRows = Math.ceil(Math.max(1, sortedGames.count) / Math.max(1, gridView.columns))
                    var currentRow = Math.floor(gridView.currentIndex / Math.max(1, gridView.columns))
                    return totalRows > 1 ? currentRow / Math.max(1, totalRows - 1) : 0
                }
                thumbRatio: (Math.max(1, gridView.height / Math.max(1, gridView.cellHeight)) * gridView.columns) / Math.max(1, sortedGames.count)
                minThumbSize: 28
            }
        }

        Item {
            id: bottomBlock
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Math.round(parent.width * 0.035)
            height: layoutMode === 0 ? (showHints ? root.height * 0.16 : 0)
            : (showHints ? root.height * 0.055 : 0)
            visible: showHints || (layoutMode === 0)

            SummaryBlock {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                width: parent.width * 0.62
                visible: layoutMode === 0 && summaryText !== ""
                summaryText: currentGame() && currentGame().summary ? currentGame().summary : ""
                textColor: colorTextSecondary
                fontFamily: global.fonts.sans
                rootHeight: root.height
            }

            HintBar {
                visible: showHints
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                height: root.height * 0.055
                hintItems: controllerHintItems
                extraWidth: Math.round(root.width * 0.04)
                panelColor: colorPanelHints
                borderColor: colorBorderHints
                textColor: colorTextHints
                fontFamily: global.fonts.sans
                textPixelSize: Math.round(root.height * 0.017)
                iconPixelSize: Math.round(root.height * 0.026)
            }
        }
    }

    OptionsModal {
        id: modalLayer
        anchors.fill: parent
        z: 100
        visible: optionsOpen
        overlayColor: colorOverlayBackground
        panelTextPrimary: colorTextPrimary
        panelTextSecondary: colorTextSecondary
        panelTextMuted: colorTextMuted
        condensedFontFamily: global.fonts.condensed
        sansFontFamily: global.fonts.sans
        hintItems: modalHintItems
        currentIndex: optionsIndex
        rowCount: optionCount()
        menuLabelFn: menuLabel
        menuValueFn: menuValue
        rootHeight: root.height
    }

    Keys.onPressed: {
        if (launchAnimating) {
            event.accepted = true
            return
        }

        if (optionsOpen && api.keys.isCancel(event)) {
            event.accepted = true
            closeOptions()
            return
        }

        // Controller Y + keyboard Y = Options
        if (event.key === Qt.Key_Y || api.keys.isFilters(event)) {
            event.accepted = true
            if (optionsOpen)
                closeOptions()
                else
                    openOptions()
                    return
        }

        // Controller X + keyboard X = Sort
        if (event.key === Qt.Key_X || api.keys.isDetails(event)) {
            event.accepted = true
            cycleSort(1)
            return
        }

        if (optionsOpen) {
            if (event.key === Qt.Key_Up) {
                event.accepted = true
                optionsIndex = (optionsIndex - 1 + optionCount()) % optionCount()
                playNav()
                return
            }
            if (event.key === Qt.Key_Down) {
                event.accepted = true
                optionsIndex = (optionsIndex + 1) % optionCount()
                playNav()
                return
            }
            if (event.key === Qt.Key_Left) {
                event.accepted = true
                menuAdjust(-1)
                return
            }
            if (event.key === Qt.Key_Right) {
                event.accepted = true
                menuAdjust(1)
                return
            }
            return
        }

        if (event.key === Qt.Key_Left) {
            event.accepted = true
            moveSelection(-1, 0)
            return
        }
        if (event.key === Qt.Key_Right) {
            event.accepted = true
            moveSelection(1, 0)
            return
        }
        if (event.key === Qt.Key_Up) {
            event.accepted = true
            moveSelection(0, -1)
            return
        }
        if (event.key === Qt.Key_Down) {
            event.accepted = true
            moveSelection(0, 1)
            return
        }
    }

    Keys.onReleased: {
        if (api.keys.isAccept(event) || event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Select) {
            event.accepted = true
            if (launchAnimating)
                return
            if (optionsOpen)
                return

            acceptReady = true
            launchCurrent()
            return
        }

        if (launchAnimating) {
            event.accepted = true
            return
        }

        if (optionsOpen && api.keys.isCancel(event)) {
            event.accepted = true
            return
        }
    }

    onSortModeChanged: restartBackgroundMotion()
    onLayoutModeChanged: restartBackgroundMotion()

    Component.onCompleted: {
        loadSettings()
        rowView.currentIndex = 0
        gridView.currentIndex = 0
        configureBackgroundMotion()
        if (bgMotionEnabled) {
            backgroundStage.zoomAnimation.start()
            backgroundStage.driftXAnimation.start()
            backgroundStage.driftYAnimation.start()
        }
        acceptReady = true
        launchBlocked = false
    }

    Component.onDestruction: saveSettings()
}
