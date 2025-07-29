import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import QtMultimedia
import QtCore


//import WorkoutDB 1.0

import "views"

ApplicationWindow {
    id: root
    visible: true
    width: 393
    height: 873
    //visibility: Window.FullScreen
    title: qsTr("HSWorkout")

    // Control Flags
    property bool mainviewIsReady: false
    onMainviewIsReadyChanged: if(mainviewIsReady) {
                                  contentLoader.active = true
                                  currentView = 0
                              }
    property int currentView: -1
    property var currentObject: null

    onCurrentViewChanged:  {
        switch(currentView) {
        case 0:
            contentLoader.sourceComponent = mainViewComp
            break
        case 1:
            contentLoader.sourceComponent = trainingComp
            break;
        case 2:
            contentLoader.sourceComponent = trainingModeComp
            break;
        }
    }


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
        opacity: !mainviewIsReady ? 0.8 : 0.3
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
        interval: 500
        running: true
        repeat: false
        onTriggered:  mainviewIsReady = true
    }

    Loader {
        id: contentLoader
        active: mainviewIsReady
        anchors.fill: parent
        sourceComponent:  mainViewComp
        onSourceComponentChanged: {
            if(contentLoader && contentLoader.item) {
                contentLoader.item.opacity = 1
            }
        }
    }

    Image {
        id: btnHome
        opacity: currentView > -1
        enabled: opacity === 1
        Behavior on opacity {OpacityAnimator{}}
        height: 55
        width: 55
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 28
        anchors.horizontalCenter: parent.horizontalCenter
        source: "qrc:/assets/icons/icon-home.png"
        scale: maX.pressed ? 0.8 : 1
        MouseArea {
            id: maX
            anchors.fill: parent
            onClicked: {
                currentView = 0
                currentObject = null
            }
        }
    }

    Component {
        id: mainViewComp
        MainView {
            id: mainViewItem
            opacity: 0
            enabled: opacity === 1
            Behavior on opacity {NumberAnimation{}}
        }
    }

    Component {
        id: homeComp
        HomeItem {
            id: homeItem
            opacity: 0
            enabled: opacity === 1
            Behavior on opacity {NumberAnimation{}}
        }
    }

    Component {
        id: trainingComp
        TrainingItem {
            id: trainingItem
            opacity: 0
            enabled: opacity === 1
            Behavior on opacity {NumberAnimation{}}
        }
    }

    Component {
        id: trainingModeComp
        TrainingModeItem {
            id: trainingModeItem
            opacity: 0
            enabled: opacity === 1
            Behavior on opacity {OpacityAnimator{}}
        }
    }


}
