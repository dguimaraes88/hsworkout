import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import QtMultimedia
import QtCore
import "qrc:/assets/treinos/PlanoTreino.js" as Treinos
//import WorkoutDB 1.0

import "views"

ApplicationWindow {
    id: _root
    visible: true
    width: 393
    height: 873
    //visibility: Window.FullScreen
    title: qsTr("HSWorkout")

    // Control Flags
    property bool mainviewIsReady: false

    //Fonts
    property alias font_orbitron_regular: _orbitron_regular.name
    property alias font_orbitron_semibold: _orbitron_semibold.name
    property alias font_orbitron_bold: _orbitron_bold.name

    //Colors
    property color color_lime: "#f5f919"

    // WorkoutManager {
    //     id: wkManager
    // }

    FontLoader {
        id: _orbitron_regular
        source: "qrc:/assets/fonts/Orbitron-Regular.ttf"
    }
    FontLoader {
        id: _orbitron_semibold
        source: "qrc:/assets/fonts/Orbitron-SemiBold.ttf"
    }
    FontLoader {
        id: _orbitron_bold
        source: "qrc:/assets/fonts/Orbitron-Bold.ttf"
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    Image {
        id: backgroundImage
        opacity: !mainviewIsReady ? 0.8 : 1
        Behavior on opacity {OpacityAnimator{}}
        anchors.fill: parent
        asynchronous: true
        source: "qrc:/assets/imgs/appBackground.png"
        fillMode: Image.PreserveAspectCrop
        layer.enabled: !mainviewIsReady
        layer.effect: FastBlur {
            anchors.fill: backgroundImage
            source: backgroundImage
            radius: 32
        }
    }
    Image {
        id: halterIcon
        opacity: !mainviewIsReady ? 1 : 0
        Behavior on opacity {OpacityAnimator{}}
        width: 128
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 64
        asynchronous: true
        source: "qrc:/assets/icons/barbell.png"
        fillMode: Image.PreserveAspectFit


        SequentialAnimation {
            running: true
            loops :Animation.Infinite


            NumberAnimation {
                target: halterIcon
                property: "scale"
                duration: 1500
                easing.type: Easing.InOutQuad
                from: 1
                to: 1.2
            }

            PauseAnimation {
                duration: 250
            }
            NumberAnimation {
                target: halterIcon
                property: "scale"
                duration: 1500
                easing.type: Easing.InOutQuad
                from: 1.2
                to: 1
            }

            PauseAnimation {
                duration: 250
            }
        }
    }

    Text {
        opacity: !mainviewIsReady ? 1 : 0
        Behavior on opacity {OpacityAnimator{}}
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -128
        font.pixelSize: 52
        font.family: font_orbitron_bold
        font.bold: true
        color: "white"
        text: "HSWorkout"
        style: Text.Outline ; styleColor: "black"
    }

    Timer {
        id: loadingTime
        interval: 2000
        running: true
        repeat: false
        onTriggered:  mainviewIsReady = true
    }

    Loader {
        id: appLoader
        active: mainviewIsReady
        anchors.fill: parent
        source: "qrc:/views/MainView.qml"
    }
}

