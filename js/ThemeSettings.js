.pragma library

function save(memory, state) {
    memory.set("dcg.layoutMode", state.layoutMode)
    memory.set("dcg.sortMode", state.sortMode)
    memory.set("dcg.sortAscending", state.sortAscending)
    memory.set("dcg.bgBlur", state.bgBlur)
    memory.set("dcg.bgDark", state.bgDark)
    memory.set("dcg.bgFallbackColor", state.bgFallbackColor.toString())
    memory.set("dcg.bgMotionEnabled", state.bgMotionEnabled)
    memory.set("dcg.showHints", state.showHints)
    memory.set("dcg.gameListScrollbarEnabled", state.gameListScrollbarEnabled)
    memory.set("dcg.soundEnabled", state.soundEnabled)
}

function load(memory, defaults, defaultSortAscendingFn) {
    var sortMode = memory.has("dcg.sortMode") ? memory.get("dcg.sortMode") : defaults.sortMode

    return {
        layoutMode: memory.has("dcg.layoutMode") ? memory.get("dcg.layoutMode") : defaults.layoutMode,
        sortMode: sortMode,
        sortAscending: memory.has("dcg.sortAscending") ? memory.get("dcg.sortAscending") : defaultSortAscendingFn(sortMode),
        bgBlur: memory.has("dcg.bgBlur") ? memory.get("dcg.bgBlur") : defaults.bgBlur,
        bgDark: memory.has("dcg.bgDark") ? memory.get("dcg.bgDark") : defaults.bgDark,
        bgFallbackColor: memory.has("dcg.bgFallbackColor") ? memory.get("dcg.bgFallbackColor") : defaults.bgFallbackColor,
        bgMotionEnabled: memory.has("dcg.bgMotionEnabled") ? memory.get("dcg.bgMotionEnabled") : defaults.bgMotionEnabled,
        showHints: memory.has("dcg.showHints") ? memory.get("dcg.showHints") : defaults.showHints,
        gameListScrollbarEnabled: memory.has("dcg.gameListScrollbarEnabled") ? memory.get("dcg.gameListScrollbarEnabled") : defaults.gameListScrollbarEnabled,
        soundEnabled: memory.has("dcg.soundEnabled") ? memory.get("dcg.soundEnabled") : defaults.soundEnabled
    }
}
