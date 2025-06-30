import QtQuick

Item {
    id: appButtonDefault
    
    property string imgSource
    property double baseScale
    
    height: 48
    width: height
    
    Image {
        id: iconImage
        width: parent.width
        height: parent.height
        scale: baseScale
        anchors.horizontalCenter: parent.horizontalCenter
        fillMode: Image.PreserveAspectFit    
        asynchronous: true
        source: imgSource
    }
}
