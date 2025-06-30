import QtQuick
import QtQuick.Controls

Item {
    id: trainingItem
    opacity: 0
    Behavior on opacity {OpacityAnimator{}}

    ListModel {
        id: listTrainingModel
        ListElement {
            trainingName: "Pernas e Glúteos A"
            trainingImg: "qrc:/assets/icons/dumbells.png"
        }
        ListElement {
            trainingName: "Costas, Peito e Braços"
            trainingImg: "qrc:/assets/icons/dumbells.png"
        }
        ListElement {
            trainingName: "Pernas e Glúteos B"
            trainingImg: "qrc:/assets/icons/dumbells.png"
        }
        ListElement {
            trainingName: "Core + Cardio ou Full Body"
            trainingImg: "qrc:/assets/icons/dumbells.png"
        }
    }

    Text {
        id: traningTitle
        anchors.left: parent.left
        anchors.leftMargin: 16
        anchors.top: parent.top
        anchors.topMargin: 16
        font.pixelSize: 28
        font.family: font_orbitron_bold
        font.bold: true
        color: "white"
        text: "Mapa de Treino"
    }

    Rectangle {
        id: hLine
        anchors.top: traningTitle.bottom
        anchors.topMargin: 8
        anchors.left: parent.left
        anchors.leftMargin: 0
        width: 393
        height: 2
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop {position: 0; color: "#b9eb01"}
            GradientStop {position: 0.95; color: "transparent"}
        }
    }

    Rectangle {
        id: contentListView
        clip: true
        radius: 16
        anchors.centerIn: trainingItem
        color: "#DD000000"
        border.color: "#b9eb01"
        height: 500
        width: 380

        ListView {
            id: traningList
            interactive: contentHeight > contentListView.height
            topMargin: 24
            anchors.left: parent.left
            anchors.leftMargin: 24
            width: parent.width - 24
            height: parent.height - 24
            spacing: 16
            model: listTrainingModel
            delegate: Column {
                width: parent.width

                Row {
                    height: 35
                    spacing: 16

                    Image {
                        id: tImage
                        asynchronous: true
                        source: trainingImg
                        fillMode: Image.PreserveAspectFit
                        height: 35
                        width: 35
                    }

                    Text {
                        width: paintedWidth + 24
                        font.pixelSize: 16
                        font.family: font_orbitron_regular
                        color: "white"
                        text: trainingName + index
                        Rectangle {
                            anchors.top: parent.bottom
                            anchors.topMargin: 8
                            width: parent.width
                            gradient: Gradient {
                                orientation: Gradient.Horizontal
                                GradientStop {position: 0; color: "#b9eb01"}
                                GradientStop {position: 0.95; color: "transparent"}
                            }
                            height: 2
                        }
                    }
                }

            }

        }
    }
}
