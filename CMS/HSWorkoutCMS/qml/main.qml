import QtQuick
import QtQuick.Controls
import Backend 1.0

ApplicationWindow {
    visible: true
    width: 960
    height: 1280
    title: "Gestor de Exercícios - CouchDB"

    property var exercicios: []
    property var listOne: []
    //Fonts
    property alias font_orbitron_regular: _orbitron_regular.name
    property alias font_orbitron_semibold: _orbitron_semibold.name
    property alias font_orbitron_bold: _orbitron_bold.name

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
        id: _appBackground
        asynchronous: true
        fillMode: Image.Stretch
        anchors.fill: parent
        opacity: 0.3
        source: "qrc:/assets/imgs/appBackground.png"
    }

    Text {
        id: appTitle
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.top: parent.top
        anchors.topMargin: 8
        font.pixelSize: 26
        font.family: font_orbitron_bold
        font.bold: true
        color: "white"
        text: "HSWorkoutCMS"
    }

    Rectangle {
        id: hLine
        anchors.top: appTitle.bottom
        anchors.topMargin: 8
        anchors.left: parent.left
        anchors.leftMargin: 0
        width: parent.width
        height: 2
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop {position: 0; color: "#b9eb01"}
            GradientStop {position: 0.95; color: "transparent"}
        }
    }

    SplitView {
        anchors.top: hLine.bottom
        anchors.topMargin: 8
        width: parent.width - leftMenu.width
        height: parent.height - appTitle.y
        orientation: Qt.Horizontal  // <- Divide na horizontal

        Item {
            SplitView.minimumWidth: 220
            SplitView.preferredWidth: 220
            SplitView.maximumWidth: 220

            Column {
                id: leftMenu
                spacing: 16
                anchors.left: parent.left
                anchors.leftMargin: 8
                width: appTitle.paintedWidth

                CmsBtn {
                    id: cmsBtnExerciciosx
                    btnLabel: "Exercícios"
                    labelFontSize: 18
                    width: 200
                    MouseArea {
                        anchors.fill: parent
                        onClicked: couch.listarEntidades("exercicio")
                    }
                }
                CmsBtn {
                    id: cmsBtnTreino
                    btnLabel: "Treino"
                    labelFontSize: 18
                    width: 200
                    MouseArea {
                        anchors.fill: parent
                        onClicked: couch.listarEntidades("treino")
                    }

                }
            }
        }

        Item {
            id: area1
            SplitView.minimumWidth: 220
            SplitView.preferredWidth: 220
            SplitView.maximumWidth: 220
            width: 220
            height: parent.height

            Row {
                id: topOptions
                height: 35
                anchors.left: parent.left
                anchors.leftMargin: 8
                spacing: 8
                CmsBtn {
                    id: cmsBtnCriar
                    btnLabel: "Criar"
                    labelFontSize: 12
                    width: 100
                    MouseArea {
                        anchors.fill: parent
                        onClicked: couch.listarEntidades("exercicio")
                    }
                }
                CmsBtn {
                    id: cmsBtnApagar
                    btnLabel: "Apagar"
                    labelFontSize: 12
                    width: 100
                    MouseArea {
                        anchors.fill: parent
                        onClicked: couch.listarEntidades("exercicio")
                    }
                }
            }

            ListView {
                id: exerciciosList2
                spacing: 8
                anchors.top: topOptions.bottom
                anchors.topMargin: 8
                anchors.left: parent.left
                anchors.leftMargin: 8
                width: parent.width
                height: 400
                model: exercicios
                delegate: CmsBtn {
                    btnLabel: modelData.titulo
                    width: 200
                    MouseArea {
                        anchors.fill: parent
                        onClicked: couch.listarExercicios()
                    }
                }
            }
        }

        Item {
            id: area2
            SplitView.minimumWidth: 220
            SplitView.preferredWidth: 220
            SplitView.maximumWidth: 220
            width: 200
            height: parent.height


            Rectangle {
                anchors.fill: parent
                color: "black"
            }
            ListView {
                id: exerciciosList3
                clip: true
                spacing: 8
                anchors.top: parent.top
                anchors.topMargin: 16
                anchors.left: parent.left
                anchors.leftMargin: 8
                width: parent.width
                height: 400
                model: exercicios
                delegate: CmsBtn {
                    btnLabel: modelData.titulo
                    width: 200
                    MouseArea {
                        anchors.fill: parent
                        onClicked: couch.listarExercicios()
                    }
                }
            }
        }

    }

    // Column {
    //     spacing: 10
    //     anchors.centerIn: parent

    //     Button {
    //         text: "Listar Exercícios"
    //         onClicked: couch.listarExercicios()
    //     }

    //     Button {
    //         text: "Inserir Exemplo"
    //         onClicked: couch.inserirExercicio("Agachamento", "Exercício de pernas", "Fácil", 30)
    //     }

    //     ListView {
    //         width: parent.width
    //         height: 400
    //         model: exercicios

    //         delegate: Rectangle {
    //             width: parent.width
    //             height: 50
    //             border.color: "grey"

    //             Row {
    //                 spacing: 10
    //                 Text { text: modelData.titulo }
    //                 Button {
    //                     text: "Editar"
    //                     onClicked: couch.editarExercicio(modelData._id, modelData._rev, "Titulo Editado", "Descricao", "Intermediário", 45)
    //                 }
    //                 Button {
    //                     text: "Apagar"
    //                     onClicked: couch.apagarExercicio(modelData._id, modelData._rev)
    //                 }
    //             }
    //         }
    //     }
    // }

    CouchDbManager {
        id: couch

        onExerciciosRecebidos: (docs) => {
                                   exercicios = docs  // Atualiza o array
                               }

        onOperacaoConcluida: (sucesso, mensagem) => {
                                 couch.listarExercicios()
                             }
    }
}
