import QtQuick

Item {
    id: homeItem
    anchors.fill: parent
    signal setCurrentObject(var obj)
    signal setCurrentView(int view)
}
