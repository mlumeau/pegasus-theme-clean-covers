import QtQuick 2.15
import SortFilterProxyModel 0.2

SortFilterProxyModel {
    id: root
    property var sourceGamesModel
    property int sortMode: 0
    property bool sortAscending: false

    sourceModel: sourceGamesModel

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
