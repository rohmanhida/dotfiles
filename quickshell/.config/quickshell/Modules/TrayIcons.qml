import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import "../Singletons"
import "./TrayIcons"

Rectangle {
    id: systemTray

    visible: SystemTray.items.values.length > 0
    width: visible ? (SystemTray.items.values.length * 25) + 20 : 0
    Layout.preferredWidth: width
    color: Theme.barColor
    height: bar.height - 16
    radius: Theme.screenRounding
    
    property var selectedMenu: null
    property int itemCount: SystemTray.items.values.length

    RowLayout {
        id: trayRow
        height: parent.height
        layoutDirection: Qt.LeftToRight
        spacing: 5

        anchors {
            right: parent.right
            rightMargin: 10
            verticalCenter: parent.verticalCenter
        }

        Repeater {
            model: SystemTray.items.values

            Item {
                id: trayIcon
                required property var modelData

                Layout.fillHeight: true
                Layout.preferredWidth: 20
                
                property bool isOpen: false

                QsMenuOpener {
                    id: trayMenuOpener
                    menu: trayIcon.modelData.menu
                }

                Image {
                    id: trayImage
                    source: parent.modelData.icon || ""
                    height: Math.min(parent.height - 4, 16)
                    width: height
                    anchors.centerIn: parent

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
                    visible: itemMenu == systemTray.selectedMenu && trayIcon.isOpen
                }
            }
        }
    }

    Behavior on Layout.preferredWidth {
        NumberAnimation {
            duration: 100
            easing.type: Easing.OutQuad
        }
    }
}
