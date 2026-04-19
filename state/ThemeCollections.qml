import QtQuick 2.15

QtObject {
    id: root

    property int activeIndex: 0
    property var allGamesModel
    property var collectionsModel

    readonly property var currentEntry: entryAt(activeIndex)
    readonly property var currentGamesModel: currentEntry && currentEntry.games
        ? currentEntry.games
        : allGamesModel
    readonly property string currentName: currentEntry && currentEntry.name
        ? currentEntry.name
        : "All games"

    function entryAt(index) {
        if (index === 0)
            return { name: "All games", games: allGamesModel }

        if (!collectionsModel || index < 1 || index > collectionsModel.count)
            return null

        var collection = collectionsModel.get(index - 1)
        if (!collection)
            return null

        return {
            name: collection.name ? collection.name : "Collection",
            games: collection.games
        }
    }

    function nextBrowsableIndex(step) {
        var total = 1 + (collectionsModel ? collectionsModel.count : 0)
        if (total <= 1)
            return activeIndex

        var direction = step >= 0 ? 1 : -1
        for (var offset = 1; offset < total; ++offset) {
            var candidateIndex = (activeIndex + direction * offset + total) % total
            var candidate = entryAt(candidateIndex)
            if (candidate && candidate.games && candidate.games.count > 0)
                return candidateIndex
        }

        return activeIndex
    }
}
