import QtQuick
import QtQuick.Controls
import Backend 1.0

ApplicationWindow {
    visible: true
    width: 1920
    height: 1080
    title: "Gestor de Exercícios - CouchDB"

    property var exercicios: []

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    Image {
        id: backgroundIamge
        asynchronous: true
        source: ""
    }

    Column {
        spacing: 10
        anchors.centerIn: parent

        Button {
            text: "Listar Exercícios"
            onClicked: couch.listarExercicios()
        }

        Button {
            text: "Inserir Exemplo"
            onClicked: couch.inserirExercicio("Agachamento", "Exercício de pernas", "Fácil", 30)
        }

        ListView {
            width: parent.width
            height: 400
            model: exercicios

            delegate: Rectangle {
                width: parent.width
                height: 50
                border.color: "grey"

                Row {
                    spacing: 10
                    Text { text: modelData.titulo }
                    Button {
                        text: "Editar"
                        onClicked: couch.editarExercicio(modelData._id, modelData._rev, "Titulo Editado", "Descricao", "Intermediário", 45)
                    }
                    Button {
                        text: "Apagar"
                        onClicked: couch.apagarExercicio(modelData._id, modelData._rev)
                    }
                }
            }
        }
    }

    CouchDbManager {
        id: couch

        onExerciciosRecebidos: (docs) => {
            exercicios = docs  // Atualiza o array
        }

        onOperacaoConcluida: (sucesso, mensagem) => {
            console.log(mensagem)
            couch.listarExercicios()
        }
    }
}
