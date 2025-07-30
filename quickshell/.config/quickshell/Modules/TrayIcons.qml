import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import "../Singletons"
import "./TrayIcons"

Rectangle {
    id: systemTray

    visible: SystemTray.items.values.length > 0
    Layout.preferredWidth: trayRow.width + 20
    color: Theme.barColor
    height: bar.height - 7
    radius: Theme.screenRounding
    // clip: true

    property var selectedMenu: null
    property int itemCount: SystemTray.items.values.length

    RowLayout {
        id: trayRow
        height: parent.height/3
        layoutDirection: Qt.LeftToRight

        anchors {
            right: parent.right
            rightMargin: 10
        }

        Repeater {
            model: SystemTray.items

            Item {
                id: trayIcon
                required property SystemTrayItem modelData

                Layout.fillHeight: true
                implicitWidth: 12

                property bool isOpen: false

                QsMenuOpener {
                    id: trayMenuOpener
                    menu: trayIcon.modelData.menu
                }

                Image {
                    source: parent.modelData.icon
                    height: width
                    anchors {
                        left: parent.left
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.AllButtons
                        scrollGestureEnabled: true

                        onClicked: event => {
                            if (event.button === Qt.LeftButton) {
                                trayIcon.modelData.activate();
                            } else if (event.button === Qt.RightButton) {
                                trayMenuOpener.menu = trayIcon.modelData.menu;
                                systemTray.selectedMenu = itemMenu;

                                const window = QsWindow.window;
                                const widgetRect = window.contentItem.mapFromItem(trayIcon, -10, trayIcon.height);

                                itemMenu.anchor.rect = widgetRect;
                                trayIcon.isOpen = true;
                            } else if (event.button === Qt.MiddleButton) {
                                trayIcon.modelData.secondaryActivate();
                            }
                        }

                        onWheel: event => {
                            event.accepted = true;
                            const points = event.angleDelta.y / 120;
                            trayIcon.modelData.scroll(points, false);
                        }
                    }
                }

                MenuList {
                    id: itemMenu

                    trayItem: trayIcon.modelData.menu
                    // offset: systemTray.itemCount - SystemTray.items.indexOf(trayIcon.modelData)
                    visible: itemMenu == systemTray.selectedMenu && trayIcon.isOpen
                }
            }
        }
    }

    // Hover {
    //     item: parent
    // }

    Behavior on Layout.preferredWidth {
        NumberAnimation {
            duration: 100
            easing.type: Easing.OutQuad
        }
    }
}
