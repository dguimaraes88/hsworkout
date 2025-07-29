import QtQuick
import QtQuick.Layouts
import "qrc:/assets/treinos/PlanoTreino.js" as Treinos


Item {
    id: mainView
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
            model: Treinos.treinos
            delegate:  Rectangle {
                Layout.alignment: Qt.AlignCenter
                color: "#80000000"
                radius: 4
                border.color: color_lime
                border.width: 2
                Layout.preferredWidth: mainView.width * 0.8
                Layout.preferredHeight: 35

                Text {
                    width: parent.width - 20
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 14
                    font.family: font_orbitron_semibold
                    color: "white"
                    text: modelData.treino
                    fontSizeMode: Text.Fit
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        mainView.changeContent(modelData, 1)
                    }
                }
            }
        }
    }

}
