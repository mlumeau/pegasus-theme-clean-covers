.pragma library

var fallbackColors = [
    { name: "Charcoal", value: "#151316" },
    { name: "Slate Blue", value: "#243052" },
    { name: "Graphite", value: "#2a2d32" },
    { name: "Burgundy", value: "#361a22" },
    { name: "Forest", value: "#183025" },
    { name: "Midnight", value: "#141c31" }
]

var controllerHintItems = [
    { icon: "../assets/controller/face-south.svg", label: "Launch" },
    { icon: "../assets/controller/face-east.svg", label: "Back" },
    { icon: "../assets/controller/face-west.svg", label: "Sort" },
    { icon: "../assets/controller/face-north.svg", label: "Options" },
    { icons: ["../assets/controller/lb.svg", "../assets/controller/rb.svg"], label: "Collections" },
    { icons: ["../assets/controller/dpad.svg", "../assets/controller/left-stick.svg"], label: "Navigate" }
]

var modalHintItems = [
    { icons: ["../assets/controller/dpad.svg", "../assets/controller/left-stick.svg"], label: "Move / Adjust" },
    { icon: "../assets/controller/face-east.svg", label: "Close" }
]

var settingsDefaults = {
    layoutMode: 1,
    sortMode: 0,
    bgBlur: 18,
    bgDark: 0.35,
    bgFallbackColor: "#2a2d32",
    bgMotionEnabled: true,
    showHints: true,
    gameListScrollbarEnabled: true,
    soundEnabled: true
}
