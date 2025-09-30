import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland

import "../../Singletons"

PopupWindow {
    id: root
    anchor.rect.x: 0
    anchor.rect.y: 0
    anchor.window: bar

    implicitWidth: stack.implicitWidth
    implicitHeight: stack.implicitHeight

    color: "white"

    required property QsMenuHandle trayItem
    // required property int offset

    mask: Region {
        item: stack
    }

    HyprlandFocusGrab {
        id: grab
        windows: [root]

        onCleared: {
            root.close();
        }

        active: trayIcon.isOpen
    }

    function close(): void {
        trayIcon.isOpen = false;
        systemTray.selectedMenu = null;
    }

    Component.onCompleted: systemTray.selectedMenu = this

    // from https://github.com/caelestia-dots/shell
    component SubMenu: Column {
        id: menu

        required property QsMenuHandle handle
        property bool isSubMenu
        property bool shown

        padding: 3.0
        spacing: 3.0

        opacity: shown ? 1 : 0
        scale: shown ? 1 : 0.8

        Component.onCompleted: shown = true

        // TODO: behavior on scale

        QsMenuOpener {
            id: menuOpener
            menu: menu.handle
        }

        Repeater {
            model: menuOpener.children

            Rectangle {
                id: menuItem
                required property QsMenuEntry modelData

                implicitWidth: 220 // TODO configure
                implicitHeight: modelData.isSeparator ? 1 : 20

                color: modelData.isSeparator ? "white" : "transparent"

                Loader {
                    id: children

                    anchors.left: parent.left
                    anchors.right: parent.right

                    active: !menuItem.modelData.isSeparator

                    sourceComponent: MouseArea {
                        id: mouseArea

                        acceptedButtons: Qt.AllButtons
                        implicitHeight: label.implicitHeight
                        implicitWidth: label.implicitWidth
                        hoverEnabled: true

                        Rectangle {
                            color: mouseArea.containsMouse ? "gray" : "white"
                            anchors.fill: parent
                        }

                        onClicked: {
                            const entry = menuItem.modelData;
                            if (entry.hasChildren) {
                                stack.push(subMenuComp.createObject(null, {
                                    handle: entry,
                                    isSubMenu: true
                                }));
                            } else {
                                menuItem.modelData.triggered();
                                root.close();
                            }
                        }

                        Loader {
                            id: icon

                            anchors.left: parent.left
                            active: menuItem.modelData.icon !== ""

                            sourceComponent: Image {
                                width: label.implicitHeight
                                height: label.implicitHeight

                                source: Quickshell.iconPath(menuItem.modelData.icon, true)
                            }
                        }

                        Text {
                            id: label

                            anchors.left: icon.right
                            anchors.leftMargin: icon.active ? 3.0 : 0

                            text: labelMetrics.elidedText
                            color: menuItem.modelData.enabled ? "black" : " red"
                            font.family: "Inter"
                        }

                        TextMetrics {
                            id: labelMetrics
                            text: menuItem.modelData.text
                            font.pointSize: label.font.pointSize
                            font.family: label.font.family

                            elide: Text.ElideRight
                            elideWidth: 200 // TODO!!
                        }

                        Loader {
                            id: expand

                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right

                            active: menuItem.modelData.hasChildren

                            sourceComponent: Text {
                                text: ">"
                            }
                        }
                    }
                }
            }
        }

        Loader {
            active: menu.isSubMenu

            sourceComponent: Item {
                implicitWidth: back.implicitWidth
                implicitHeight: back.implicitHeight + 20 // TODO: theme

                Item {
                    anchors.bottom: parent.bottom
                    implicitWidth: back.implicitWidth
                    implicitHeight: back.implicitHeight

                    MouseArea {
                        id: backMouseArea
                        anchors.fill: parent
                        hoverEnabled: true

                        onClicked: {
                            stack.pop();
                        }

                        Rectangle {
                            color: backMouseArea.containsMouse ? "white" : "grey"
                            anchors.fill: parent

                            Row {
                                id: back
                                anchors.verticalCenter: parent.verticalCenter

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "<"
                                    color: "red"
                                }

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "Back"
                                    color: "red"
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    StackView {
        id: stack

        implicitWidth: currentItem.implicitWidth
        implicitHeight: currentItem.implicitHeight

        initialItem: SubMenu {
            id: subMenu
            isSubMenu: false
            handle: root.trayItem
        }
    }

    Component {
        id: subMenuComp

        SubMenu {}
    }
}
