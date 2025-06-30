import QtQuick

Item {
    id: mainView
    anchors.fill: parent

    Text {
        anchors.centerIn: parent
        font.pixelSize: 50
        color: "white"
        text: _root.width + " - " + parent.width + " - " + parent.height
    }


    Row {
        height: 128
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter

        AppButtonDefault {
            id: appButtonDefault
            imgSource: "qrc:/assets/icons/icon-home.png"
        }
    }

}
