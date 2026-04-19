.pragma library

function clamp(v, a, b) {
    return Math.max(a, Math.min(b, v))
}

function randRange(minV, maxV) {
    return minV + Math.random() * (maxV - minV)
}

function randDifferent(start, minV, maxV, minDelta) {
    var value = randRange(minV, maxV)
    if (Math.abs(value - start) >= minDelta)
        return value

    var dir = value >= start ? 1 : -1
    value = clamp(start + dir * minDelta, minV, maxV)
    if (Math.abs(value - start) >= minDelta)
        return value

    return clamp(start - dir * minDelta, minV, maxV)
}

function fallbackColorName(currentColor, fallbackColors) {
    var current = currentColor.toString()
    for (var i = 0; i < fallbackColors.length; ++i) {
        if (fallbackColors[i].value === current)
            return fallbackColors[i].name
    }
    return "Custom"
}

function coverSource(game) {
    if (!game) return ""
    if (game.assets.poster) return game.assets.poster
    if (game.assets.boxFront) return game.assets.boxFront
    if (game.assets.tile) return game.assets.tile
    return ""
}

function bgSource(game) {
    if (!game) return ""
    if (game.assets.banner) return game.assets.banner
    if (game.assets.steam) return game.assets.steam
    if (game.assets.background) return game.assets.background
    if (game.assets.screenshot) return game.assets.screenshot
    if (game.assets.titlescreen) return game.assets.titlescreen
    return ""
}

function secondaryText(game) {
    if (!game) return ""
    var parts = []
    if (game.developer) parts.push(game.developer)
    return parts.join("  •  ")
}

function hasValue(v) {
    return v !== undefined && v !== null && v !== ""
}

function safeDate(v) {
    if (!hasValue(v))
        return null
    var d = new Date(v)
    if (isNaN(d.getTime()))
        return null
    return d
}

function formatDateShort(v) {
    var d = safeDate(v)
    if (!d)
        return ""
    var day = d.getDate()
    var month = d.getMonth() + 1
    var year = d.getFullYear()
    return year + "-" + (month < 10 ? "0" + month : month) + "-" + (day < 10 ? "0" + day : day)
}

function formatDurationSeconds(totalSeconds) {
    if (!hasValue(totalSeconds))
        return ""
    var s = Number(totalSeconds)
    if (!isFinite(s) || s <= 0)
        return ""
    var hours = Math.floor(s / 3600)
    var minutes = Math.floor((s % 3600) / 60)
    if (hours > 0 && minutes > 0)
        return hours + "h " + minutes + "m"
    if (hours > 0)
        return hours + "h"
    if (minutes > 0)
        return minutes + "m"
    return Math.floor(s) + "s"
}

function metaText(game) {
    if (!game)
        return ""

    var parts = []
    var playTimeText = formatDurationSeconds(game.playTime)
    if (playTimeText !== "")
        parts.push("Playtime: " + playTimeText)

    var lastPlayedText = formatDateShort(game.lastPlayed)
    if (lastPlayedText !== "")
        parts.push("Last played: " + lastPlayedText)

    var installDateText = formatDateShort(game.added)
    if (installDateText !== "")
        parts.push("Installed: " + installDateText)

    if (hasValue(game.releaseYear) && Number(game.releaseYear) > 0)
        parts.push("Release year: " + game.releaseYear)

    return parts.join("  •  ")
}
