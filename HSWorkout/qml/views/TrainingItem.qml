import QtQuick
import QtQuick.Controls
import QtQuick.Layouts


Item {
    id: trainingItem
    anchors.fill: parent

        function changeContent(obj, view)
        {
            root.currentObject = obj
            root.currentView = view
        }

    ColumnLayout {
        id: mainViewButtons
        spacing: 12
        anchors.top: parent.top
        anchors.topMargin: 100
        anchors.horizontalCenter: parent.horizontalCenter

        Repeater {
            id: mainMenusRepeater
            model: currentObject ? currentObject.exercicios : []

            delegate: Rectangle {
                property var isGroup: modelData.grupo
                Layout.alignment: Qt.AlignCenter
                color:  isGroup ?  color_lime : "#80000000"
                radius: 4
                border.color: color_lime
                border.width: 2
                Layout.preferredWidth: trainingItem.width * 0.8
                Layout.preferredHeight: 35

                Text {
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 14
                    font.family: font_orbitron_semibold
                    color: isGroup ? "black" : "white"
                    text: isGroup ? modelData.grupo : modelData.exercicio || ""
                    fontSizeMode: Text.Fit
                    width: parent.width - 20
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if(isGroup ) return
                       trainingItem.changeContent(modelData, 2, currentObject)
                    }
                }
            }
        }
    }
}
