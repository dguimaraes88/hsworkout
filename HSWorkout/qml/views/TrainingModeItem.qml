import QtQuick
import QtQuick.Controls
import QtWebView
import QtQuick.Layouts
Item {
    id: trainingModeItem
    anchors.fill: parent

    function changeContent(obj, view)
    {
        root.currentObject = obj
        root.currentView = view
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop {position: 0.7; color: "black"}
            GradientStop {position: 0.95; color: "transparent"}
        }
    }

    WebView {
        id: webViewItem
        width: trainingModeItem.width
        height: width
        url: root.currentObject.video !== "" ? "https://www.youtube.com/embed/" + root.currentObject.video : ""
    }

    Rectangle {
        width: parent.width
        height: 60
        color: "black"
    }

    Text {
        id: exerciseTile
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 22
        font.pixelSize: 14
        font.family: font_orbitron_bold
        font.bold: true
        color: "white"
        text:  root.currentObject.exercicio
    }

    Column {
        width: parent.width * 0.8
        anchors.top: webViewItem.bottom
        anchors.topMargin: 8
        spacing: 8

        Text {
            leftPadding: 20
            font.pixelSize: 16
            font.family: font_orbitron_regular
            font.bold: true
            color: "white"
            text:  "Series: " + root.currentObject.series
        }
        Text {
            leftPadding: 20
            font.pixelSize: 16
            font.family: font_orbitron_regular
            font.bold: true
            color: "white"
            text:  "Repetições: " + root.currentObject.repeticoes
        }
        Text {
            leftPadding: 20
            font.pixelSize: 16
            font.family: font_orbitron_regular
            font.bold: true
            color: "white"
            text:  "Peso: " + root.currentObject.carga
        }
        Text {
            leftPadding: 20
            font.pixelSize: 16
            font.family: font_orbitron_regular
            font.bold: true
            color: "white"
            text:  "Duração: " + root.currentObject.duracao
        }
        Text {
            leftPadding: 20
            font.pixelSize: 16
            font.family: font_orbitron_regular
            font.bold: true
            color: "white"
            text:  "Descanso: " + root.currentObject.descanso
        }
    }
    property bool timerStart: false
    Timer {
        id: counterTimer
        property int tmpTime: root.currentObject.duracao
        interval: 1000
        running: timerStart
        repeat: true
        onTriggered: {
            if(tmpTime > 0){ tmpTime-- }
            else {
                timerStart = false
                tmpTime = root.currentObject.duracao
            }
        }
    }



    Rectangle {
        id: statusExercise
        color: counterTimer.tmpTime > 10 ? "darkgreen" : "red"
        Behavior on color {ColorAnimation{ duration: 1000}}
        border.color: "white"
        border.width: 2
        width: parent.width * 0.3
        height: width
        radius: width / 2
        anchors.top: webViewItem.bottom
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20

        SequentialAnimation {
            id: animX
            running: timerStart
            loops: Animation.Infinite

            NumberAnimation {
                target: statusExercise
                property: "scale"
                duration: 450
                from: 1
                to: 0.8
                easing.type: Easing.InOutQuad
            }

            PauseAnimation {
                duration: 50
            }
            NumberAnimation {
                target: statusExercise
                property: "scale"
                duration: 450
                from: 0.8
                to: 1
                easing.type: Easing.InOutQuad
            }
        }

        Text {
            anchors.centerIn: parent
            font.pixelSize: 30
            font.family: font_orbitron_regular
            font.bold: true
            color: "black"
            text: timerStart ? counterTimer.tmpTime : "Start"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if( counterTimer.tmpTime <= 0) return
                timerStart = true
            }
        }
    }
}
