.pragma library

var layoutNames = ["Row", "Grid"]

function fallbackColorIndex(currentColor, fallbackColors) {
    var current = currentColor.toString()
    for (var i = 0; i < fallbackColors.length; ++i) {
        if (fallbackColors[i].value === current)
            return i
    }
    return 0
}

function nextFallbackColor(currentColor, fallbackColors, step) {
    var index = fallbackColorIndex(currentColor, fallbackColors)
    return fallbackColors[(index + step + fallbackColors.length) % fallbackColors.length].value
}

function optionCount() {
    return 9
}

function menuLabel(index) {
    switch (index) {
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

function menuValue(index, state, helperFns) {
    switch (index) {
        case 0: return helperFns.sortDisplayName(state.sortMode, state.sortAscending)
        case 1: return layoutNames[state.layoutMode]
        case 2: return String(Math.round(state.bgBlur))
        case 3: return String(Math.round(state.bgDark * 100)) + "%"
        case 4: return helperFns.fallbackColorName(state.bgFallbackColor, state.fallbackColors)
        case 5: return state.bgMotionEnabled ? "Enabled" : "Disabled"
        case 6: return state.showHints ? "Enabled" : "Disabled"
        case 7: return state.gameListScrollbarEnabled ? "Enabled" : "Disabled"
        case 8: return state.soundEnabled ? "Enabled" : "Disabled"
        default: return ""
    }
}
