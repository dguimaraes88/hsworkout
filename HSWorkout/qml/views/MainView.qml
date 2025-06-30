import QtQuick

Item {
    id: mainView
    anchors.fill: parent

    property int currentView: -1

    Component.onCompleted: {
        currentView = 0
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
        }
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

    Row {
        height: 100
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 16
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 36

        AppButtonDefault {
            id: appButtonDefault1
            baseScale: 1
            imgSource: "qrc:/assets/icons/workout.png"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    currentView = 1
                }
            }
        }
        AppButtonDefault {
            id: appButtonDefault2
            baseScale: 1.5
            imgSource: "qrc:/assets/icons/icon-home.png"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    currentView = 0
                }
            }
        }
        AppButtonDefault {
            id: appButtonDefault3
            baseScale: 1
            imgSource: "qrc:/assets/icons/workout.png"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    currentView = 2
                }
            }
        }
    }

}
