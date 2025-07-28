import QtQuick
import QtQuick.Controls

Item {
    id: trainingModeItem
    Text {
        id: exerciseTile
        anchors.left: parent.left
        anchors.leftMargin: 16
        anchors.top: parent.top
        anchors.topMargin: 16
        font.pixelSize: 16
        font.family: font_orbitron_bold
        font.bold: true
        color: "white"
        text: currentObject.object.exerciseName
    }
}
