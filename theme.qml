import QtQuick 2.15
import "browser" as Browser
import "controllers" as Controllers
import "js/ThemeHelpers.js" as ThemeHelpers
import "js/ThemeSort.js" as ThemeSort
import "state" as State
import "ui" as UI

FocusScope {
    id: root
    focus: true

    State.ThemePalette {
        id: palette
    }

    State.ThemeState {
        id: state
    }

    State.ThemeAudio {
        id: audio
        enabled: state.soundEnabled
    }

    Controllers.BackgroundMotionController {
        id: motionController
        stage: backgroundStage
        enabled: state.bgMotionEnabled
    }

    Browser.SortedGamesModel {
        id: sortedGames
        sourceGamesModel: api.allGames
        sortMode: state.sortMode
        sortAscending: state.sortAscending
    }

    UI.BackgroundStage {
        id: backgroundStage
        anchors.fill: parent
        fallbackColor: state.bgFallbackColor
        backgroundSource: ThemeHelpers.bgSource(browser.currentGame)
        blurRadius: state.bgBlur
        darkAmount: state.bgDark
        gradientTop: palette.overlayGradientTop
        gradientMiddle: palette.overlayGradientMiddle
        gradientBottom: palette.overlayGradientBottom
        initialScale: motionController.startScale
    }

    Controllers.LaunchController {
        id: launchController
        anchors.fill: parent
        z: 80
    }

    State.ThemeActions {
        id: actions
        state: state
        browser: browser
        audio: audio
        launchController: launchController
        motionController: motionController
        memory: api.memory
    }

    State.ThemeBootstrap {
        id: bootstrap
        state: state
        browser: browser
        motionController: motionController
        launchController: launchController
        memory: api.memory
    }

    Controllers.OptionsController {
        id: optionsController
        sortMode: state.sortMode
        sortAscending: state.sortAscending
        layoutMode: state.layoutMode
        bgBlur: state.bgBlur
        bgDark: state.bgDark
        bgFallbackColor: state.bgFallbackColor
        bgMotionEnabled: state.bgMotionEnabled
        showHints: state.showHints
        gameListScrollbarEnabled: state.gameListScrollbarEnabled
        soundEnabled: state.soundEnabled
        fallbackColors: state.fallbackColors
        sortDisplayNameFn: ThemeSort.displayName
        fallbackColorNameFn: ThemeHelpers.fallbackColorName
        onOpened: audio.playMenuOpen()
        onClosed: audio.playBack()
        onNavigateRequested: audio.playNav()
        onCycleSortRequested: actions.cycleSort(step)
        onCycleLayoutRequested: actions.cycleLayout(step)
        onAdjustBlurRequested: actions.adjustBlur(step)
        onAdjustDarkRequested: actions.adjustDark(step)
        onCycleFallbackColorRequested: actions.cycleFallbackColor(step)
        onToggleMotionRequested: actions.toggleMotion()
        onToggleHintsRequested: actions.toggleHints()
        onToggleGameListScrollbarRequested: actions.toggleGameListScrollbar()
        onToggleSoundRequested: actions.toggleSound()
    }

    Browser.GameBrowser {
        id: browser
        anchors.fill: parent
        layoutMode: state.layoutMode
        showHints: state.showHints
        gameListScrollbarEnabled: state.gameListScrollbarEnabled
        gamesModel: sortedGames
        bgFallbackColor: state.bgFallbackColor
        colorTextPrimary: palette.textPrimary
        colorTextSecondary: palette.textSecondary
        colorTextMuted: palette.textMuted
        colorTextInactive: palette.textInactive
        colorTextPlaceholder: palette.textPlaceholder
        colorTextPlaceholderMeta: palette.textPlaceholderMeta
        colorTextSort: palette.textSort
        colorTextHints: palette.textHints
        colorCardBase: palette.cardBase
        colorPanelHints: palette.panelHints
        colorBorderHints: palette.borderHints
        controllerHintItems: state.controllerHintItems
        sortMode: state.sortMode
        sortAscending: state.sortAscending
        condensedFontFamily: global.fonts.condensed
        sansFontFamily: global.fonts.sans
        coverSourceFn: ThemeHelpers.coverSource
        secondaryTextFn: ThemeHelpers.secondaryText
        metaTextFn: ThemeHelpers.metaText
        onNavigateRequested: audio.playNav()
        onLaunchRequested: actions.launchCurrent()
        onFocusRequested: root.forceActiveFocus()
        onCurrentIndexChanged: {
            if ((layoutMode === 0 || layoutMode === 1) && visible)
                motionController.restart()
        }
    }

    UI.OptionsModal {
        id: modalLayer
        anchors.fill: parent
        z: 100
        visible: optionsController.open
        overlayColor: palette.overlayBackground
        panelTextPrimary: palette.textPrimary
        panelTextSecondary: palette.textSecondary
        panelTextMuted: palette.textMuted
        condensedFontFamily: global.fonts.condensed
        sansFontFamily: global.fonts.sans
        hintItems: state.modalHintItems
        currentIndex: optionsController.currentIndex
        rowCount: optionsController.optionCount()
        menuLabelFn: optionsController.menuLabel
        menuValueFn: optionsController.menuValue
        rootHeight: root.height
    }

    Controllers.InputRouter {
        anchors.fill: parent
        focus: true
        optionsOpen: optionsController.open
        launchAnimating: launchController.animating
        onCloseOptionsRequested: optionsController.closeMenu()
        onToggleOptionsRequested: {
            if (optionsController.open)
                optionsController.closeMenu()
            else
                optionsController.openMenu()
        }
        onCycleSortRequested: actions.cycleSort(1)
        onOptionMoveRequested: optionsController.moveCurrent(step)
        onOptionAdjustRequested: optionsController.adjustCurrent(step)
        onSelectionMoveRequested: actions.moveSelection(dx, dy, optionsController.open)
        onLaunchRequested: {
            state.acceptReady = true
            actions.launchCurrent()
        }
    }

    Connections {
        target: state
        function onSortModeChanged() { motionController.restart() }
        function onLayoutModeChanged() { motionController.restart() }
    }

    Component.onCompleted: bootstrap.initialize()

    Component.onDestruction: bootstrap.shutdown()
}
