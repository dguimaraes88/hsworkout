import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import QtMultimedia
import QtCore

import "views"

ApplicationWindow {
    id: _root
    visible: true
    width: Screen.width
    height: Screen.height
    visibility: Window.FullScreen
    title: qsTr("HSWorkout")

    // Control Flags
    property bool mainviewIsReady: false

    //Fonts
    property alias font_myriadPro_regular: _myriadPro_regular.name
    property alias font_myriadPro_italic: _myriadPro_italic.name
    property alias font_myriadPro_semibold: _myriadPro_semibold.name
    property alias font_myriadPro_bold: _myriadPro_bold.name

    FontLoader {
        id: _myriadPro_regular
        source: "qrc:/assets/fonts/MyriadPro-Regular.otf"
    }
    FontLoader {
        id: _myriadPro_italic
        source: "qrc:/assets/fonts/MyriadPro-It.otf"
    }
    FontLoader {
        id: _myriadPro_semibold
        source: "qrc:/assets/fonts/MyriadPro-Semibold.otf"
    }
    FontLoader {
        id: _myriadPro_bold
        source: "qrc:/assets/fonts/MyriadPro-Bold.otf"
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    Image {
        id: backgroundImage
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        asynchronous: true
        source: "qrc:/assets/imgs/appBackground.png"
        fillMode: Image.PreserveAspectFit
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
        width: 328
        anchors.centerIn: parent
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

    Timer {
        id: loadingTime
        interval: 2000
        running: true
        repeat: false
        onTriggered: mainviewIsReady = true
    }

    Loader {
        id: appLoader
        active: mainviewIsReady
        anchors.fill: backgroundImage
        source: "qrc:/views/MainView.qml"
    }
}

