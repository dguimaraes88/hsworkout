import QtQuick
import QtQuick.Controls
import Backend 1.0

Item {
    id: cmsBtn
    width: labelTxt.width + 16
    height: 35

    property string btnLabel
    property int labelFontSize
    
    Rectangle {
        anchors.fill: parent
        color: "#DD000000"
        border.color: "#b9eb01"
    }
    
    Text {
        id: labelTxt
        anchors.centerIn: parent
        font.pixelSize: labelFontSize
        font.family: font_orbitron_regular
        color: "white"
        text: btnLabel
    }
}
