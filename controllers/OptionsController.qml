import QtQuick 2.15
import "../js/ThemeOptions.js" as ThemeOptions

Item {
    id: root

    property bool open: false
    property int currentIndex: 0

    property int sortMode: 0
    property bool sortAscending: false
    property int layoutMode: 0
    property real bgBlur: 18
    property real bgDark: 0.35
    property color bgFallbackColor: "#2a2d32"
    property bool bgMotionEnabled: true
    property bool showHints: true
    property bool gameListScrollbarEnabled: true
    property bool soundEnabled: true
    property var fallbackColors: []

    property var sortDisplayNameFn
    property var fallbackColorNameFn

    signal opened()
    signal closed()
    signal navigateRequested()
    signal cycleSortRequested(int step)
    signal cycleLayoutRequested(int step)
    signal adjustBlurRequested(real step)
    signal adjustDarkRequested(real step)
    signal cycleFallbackColorRequested(int step)
    signal toggleMotionRequested()
    signal toggleHintsRequested()
    signal toggleGameListScrollbarRequested()
    signal toggleSoundRequested()

    function optionCount() { return ThemeOptions.optionCount() }
    function menuLabel(index) { return ThemeOptions.menuLabel(index) }

    function menuValue(index) {
        return ThemeOptions.menuValue(index, {
            sortMode: sortMode,
            sortAscending: sortAscending,
            layoutMode: layoutMode,
            bgBlur: bgBlur,
            bgDark: bgDark,
            bgFallbackColor: bgFallbackColor,
            bgMotionEnabled: bgMotionEnabled,
            showHints: showHints,
            gameListScrollbarEnabled: gameListScrollbarEnabled,
            soundEnabled: soundEnabled,
            fallbackColors: fallbackColors
        }, {
            sortDisplayName: sortDisplayNameFn,
            fallbackColorName: fallbackColorNameFn
        })
    }

    function openMenu() {
        open = true
        currentIndex = 0
        opened()
    }

    function closeMenu() {
        open = false
        closed()
    }

    function moveCurrent(step) {
        currentIndex = (currentIndex + step + optionCount()) % optionCount()
        navigateRequested()
    }

    function adjustCurrent(step) {
        switch (currentIndex) {
            case 0: cycleSortRequested(step); break
            case 1: cycleLayoutRequested(step); break
            case 2: adjustBlurRequested(step * 2); break
            case 3: adjustDarkRequested(step * 0.05); break
            case 4: cycleFallbackColorRequested(step); break
            case 5: if (step !== 0) toggleMotionRequested(); break
            case 6: if (step !== 0) toggleHintsRequested(); break
            case 7: if (step !== 0) toggleGameListScrollbarRequested(); break
            case 8: if (step !== 0) toggleSoundRequested(); break
        }
    }
}
