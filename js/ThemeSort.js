.pragma library

var names = ["Last played", "Title", "Release year", "Play count", "Play time"]

var variants = [
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

function defaultAscending(mode) {
    return mode === 1
}

function currentVariantIndex(sortMode, sortAscending) {
    for (var i = 0; i < variants.length; ++i) {
        if (variants[i].mode === sortMode && variants[i].ascending === sortAscending)
            return i
    }
    return 0
}

function nextVariant(sortMode, sortAscending, step) {
    var index = currentVariantIndex(sortMode, sortAscending)
    return variants[(index + step + variants.length) % variants.length]
}

function iconSource(sortMode) {
    switch (sortMode) {
        case 0: return "../assets/sort/last-played.svg"
        case 1: return "../assets/sort/title.svg"
        case 2: return "../assets/sort/release-year.svg"
        case 3: return "../assets/sort/play-count.svg"
        case 4: return "../assets/sort/play-time.svg"
        default: return "../assets/sort/last-played.svg"
    }
}

function iconScale(sortMode) {
    switch (sortMode) {
        case 0: return 0.94
        case 1: return 1.08
        case 2: return 0.92
        case 3: return 1.06
        case 4: return 1.0
        default: return 1.0
    }
}

function displayName(sortMode, sortAscending) {
    switch (sortMode) {
        case 0: return "Last played - " + (sortAscending ? "asc." : "desc.")
        case 1: return "Title - " + (sortAscending ? "A-Z" : "Z-A")
        case 2: return "Release year - " + (sortAscending ? "asc." : "desc.")
        case 3: return "Play count - " + (sortAscending ? "asc." : "desc.")
        case 4: return "Play time - " + (sortAscending ? "asc." : "desc.")
        default: return names[sortMode]
    }
}
