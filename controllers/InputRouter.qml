import QtQuick 2.15

Item {
    id: root

    property bool optionsOpen: false
    property bool launchAnimating: false
    property bool cancelPressedInOptions: false

    signal closeOptionsRequested()
    signal toggleOptionsRequested()
    signal cycleSortRequested()
    signal optionMoveRequested(int step)
    signal optionAdjustRequested(int step)
    signal selectionMoveRequested(int dx, int dy)
    signal launchRequested()

    Keys.onPressed: {
        if (launchAnimating) {
            event.accepted = true
            return
        }

        if (optionsOpen && api.keys.isCancel(event)) {
            event.accepted = true
            closeOptionsRequested()
            return
        }

        if (event.key === Qt.Key_Y || api.keys.isFilters(event)) {
            event.accepted = true
            toggleOptionsRequested()
            return
        }

        if (event.key === Qt.Key_X || api.keys.isDetails(event)) {
            event.accepted = true
            cycleSortRequested()
            return
        }

        if (optionsOpen) {
            if (event.key === Qt.Key_Up) {
                event.accepted = true
                optionMoveRequested(-1)
                return
            }
            if (event.key === Qt.Key_Down) {
                event.accepted = true
                optionMoveRequested(1)
                return
            }
            if (event.key === Qt.Key_Left) {
                event.accepted = true
                optionAdjustRequested(-1)
                return
            }
            if (event.key === Qt.Key_Right) {
                event.accepted = true
                optionAdjustRequested(1)
                return
            }
            return
        }

        if (event.key === Qt.Key_Left) {
            event.accepted = true
            selectionMoveRequested(-1, 0)
            return
        }
        if (event.key === Qt.Key_Right) {
            event.accepted = true
            selectionMoveRequested(1, 0)
            return
        }
        if (event.key === Qt.Key_Up) {
            event.accepted = true
            selectionMoveRequested(0, -1)
            return
        }
        if (event.key === Qt.Key_Down) {
            event.accepted = true
            selectionMoveRequested(0, 1)
            return
        }
    }

    Keys.onReleased: {
        if (api.keys.isAccept(event) || event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Select) {
            event.accepted = true
            if (launchAnimating || optionsOpen)
                return

            launchRequested()
            return
        }

        if (launchAnimating) {
            event.accepted = true
            return
        }

        if (optionsOpen && api.keys.isCancel(event)) {
            event.accepted = true
        }
    }
}
