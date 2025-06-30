import QtQuick

Item {
    id: appButtonDefault
    
    property string imgSource
    
    height: 100
    width: height
    
    Image {
        id: iconImage
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent
        asynchronous: true
        source: imgSource
    }
}
