import QtQuick
import QtQuick.Layouts

Item {
    id: mainView
    anchors.fill: parent

    property int currentView: -1
    property var currentObject: null

    onCurrentObjectChanged:  {
        console.log("CURRENT BJECT CHANGED: ", currentObject, typeof(currentObject))
        currentView = 3
    }

    onCurrentViewChanged:  {
        switch(currentView) {
        case 0:
            contentLoader.sourceComponent = homeComp
            break
        case 1:
            contentLoader.sourceComponent = trainingComp
            break
        case 2:
            contentLoader.sourceComponent = homeComp
            break

        case 3:
            contentLoader.sourceComponent = trainingModeComp
            break
        }
    }


    Component.onCompleted: {
        currentView = 0
        console.log("TREINOS: ", Treinos, Treinos.treinos, _root.Treinos)
    }

    Component {
        id: homeComp
        HomeItem {
            id: homeItem
        }
    }
    Component {
        id: trainingComp
        TrainingItem {
            id: trainingItem
        }
    }
    Component {
        id: trainingModeComp
        TrainingModeItem {
            id: trainingModeItem
        }
    }


    Loader {
        id: contentLoader
        width: parent.width
        height: parent.height
        asynchronous: true
        active: true
        sourceComponent: homeComp
        onSourceComponentChanged: {
            contentLoader.item.opacity = 1
        }
    }

    ColumnLayout {
        id: mainViewButtons
        anchors.top: parent.top
        anchors.topMargin: 80
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
            }
        }

    }



}
