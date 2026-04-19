import QtQuick 2.15
import "../js/ThemeConfig.js" as ThemeConfig
import "../js/ThemeSettings.js" as ThemeSettings
import "../js/ThemeSort.js" as ThemeSort

QtObject {
    property int layoutMode: ThemeConfig.settingsDefaults.layoutMode
    property int sortMode: ThemeConfig.settingsDefaults.sortMode
    property bool sortAscending: ThemeSort.defaultAscending(layoutMode)
    property real bgBlur: ThemeConfig.settingsDefaults.bgBlur
    property real bgDark: ThemeConfig.settingsDefaults.bgDark
    property color bgFallbackColor: ThemeConfig.settingsDefaults.bgFallbackColor
    property bool bgMotionEnabled: ThemeConfig.settingsDefaults.bgMotionEnabled
    property bool showHints: ThemeConfig.settingsDefaults.showHints
    property bool gameListScrollbarEnabled: ThemeConfig.settingsDefaults.gameListScrollbarEnabled
    property bool soundEnabled: ThemeConfig.settingsDefaults.soundEnabled
    property bool acceptReady: true

    readonly property var fallbackColors: ThemeConfig.fallbackColors
    readonly property var controllerHintItems: ThemeConfig.controllerHintItems
    readonly property var modalHintItems: ThemeConfig.modalHintItems

    function save(memory) {
        ThemeSettings.save(memory, {
            layoutMode: layoutMode,
            sortMode: sortMode,
            sortAscending: sortAscending,
            bgBlur: bgBlur,
            bgDark: bgDark,
            bgFallbackColor: bgFallbackColor,
            bgMotionEnabled: bgMotionEnabled,
            showHints: showHints,
            gameListScrollbarEnabled: gameListScrollbarEnabled,
            soundEnabled: soundEnabled
        })
    }

    function load(memory) {
        var loaded = ThemeSettings.load(memory, ThemeConfig.settingsDefaults, ThemeSort.defaultAscending)
        layoutMode = loaded.layoutMode
        sortMode = loaded.sortMode
        sortAscending = loaded.sortAscending
        bgBlur = loaded.bgBlur
        bgDark = loaded.bgDark
        bgFallbackColor = loaded.bgFallbackColor
        bgMotionEnabled = loaded.bgMotionEnabled
        showHints = loaded.showHints
        gameListScrollbarEnabled = loaded.gameListScrollbarEnabled
        soundEnabled = loaded.soundEnabled
    }
}
