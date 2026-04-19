import QtQuick 2.15
import QtMultimedia 5.15

Item {
    property bool enabled: true

    function play(effect) {
        if (!enabled || !effect)
            return
        effect.stop()
        effect.play()
    }

    function playNav()      { play(navEffect) }
    function playBack()     { play(backEffect) }
    function playSort()     { play(sortEffect) }
    function playLayout()   { play(layoutEffect) }
    function playAdjust()   { play(adjustEffect) }
    function playMenuOpen() { play(menuOpenEffect) }
    function playLaunch()   { play(launchEffect) }

    SoundEffect { id: launchEffect;   source: "../assets/audio/launch.wav";    volume: 0.75 }
    SoundEffect { id: backEffect;     source: "../assets/audio/back.wav";      volume: 0.85 }
    SoundEffect { id: navEffect;      source: "../assets/audio/navigate.wav";  volume: 0.55 }
    SoundEffect { id: layoutEffect;   source: "../assets/audio/layout.wav";    volume: 0.75 }
    SoundEffect { id: sortEffect;     source: "../assets/audio/sort.wav";      volume: 0.75 }
    SoundEffect { id: menuOpenEffect; source: "../assets/audio/menu-open.wav"; volume: 0.75 }
    SoundEffect { id: adjustEffect;   source: "../assets/audio/adjust.wav";    volume: 0.70 }
}
