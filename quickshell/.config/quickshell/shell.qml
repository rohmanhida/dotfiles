import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

import "Singletons"
import "Windows" as Windows
import "Modules"

ShellRoot {
    id: shell

    readonly property Toplevel activeWindow: ToplevelManager.activeToplevel

    Variants {
        model: Quickshell.screens
        delegate: PanelWindow {
            id: bar
            property var modelData
            screen: modelData

            anchors {
                left: true
                right: true
                top: true
            }

            // Bar window is taller to accommodate the rounded decoration
            implicitHeight: Theme.barHeight + Theme.screenRounding

            color: "transparent"

            Item {
                id: barContent
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                }
                height: Theme.barHeight

                // Main bar background
                Rectangle {
                    id: barBackground
                    anchors.fill: parent
                    color: Theme.barColor
                    // No radius on the bar itself - it's straight
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    spacing: 24

                    // Left section - Workspaces, active window
                    Row {
                        Column {
                            Layout.alignment: Qt.AlignLeft
                            Text {
                                text: shell.activeWindow?.appId ?? "Kanji"
                                color: Theme.textColor
                                font.pixelSize: 12
                                font.weight: Font.Bold
                                font.family: "Inter"
                            }
                            Text {
                                text: shell.activeWindow?.title ?? "Pentol"
                                color: Theme.textColor
                                font.pixelSize: 10
                                font.weight: Font.Regular
                                font.family: "Inter"
                            }
                        }
                    }
                    Row {
                        Layout.fillWidth: false
                        spacing: 5
                        Layout.alignment: Qt.AlignVCenter

                        Repeater {
                            model: 5

                            delegate: Rectangle {
                                property bool isActive: Hyprland.focusedWorkspace && Hyprland.focusedWorkspace.id === (index + 1)
                                property bool hasWindows: {
                                    var workspace = Hyprland.workspaces.values.find(ws => ws.id === (index + 1));
                                    return workspace?.id > 0;
                                }

                                width: 6
                                height: 6
                                radius: 3

                                color: {
                                    if (isActive) {
                                        return Theme.textColor;
                                    } else if (hasWindows) {
                                        return Theme.inactiveColor;
                                    } else {
                                        return Qt.rgba(Theme.inactiveColor.r, Theme.inactiveColor.g, Theme.inactiveColor.b, 0.3);
                                    }
                                }

                                Behavior on color {
                                    ColorAnimation {
                                        duration: 150
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    anchors.margins: -4
                                    onClicked: Hyprland.dispatch("workspace", (index + 1).toString())
                                }
                            }
                        }
                    }
                    Item {
                        Layout.fillWidth: true
                    }
                    Item {
                        Layout.fillWidth: true
                    }

                    // Right section (time, notification, tray)
                    Row {
                        Layout.fillWidth: false
                        spacing: 12
                        Layout.alignment: Qt.AlignVCenter
                        Text {
                            id: timeText
                            text: Qt.formatDateTime(new Date(), "ddd, MMM d hh:mm")
                            color: Theme.textColor
                            font.pixelSize: 11
                            font.weight: Font.Medium
                            font.family: "Inter"
                        }

                        TrayIcons {}
                    }
                }
            }

            // Round decorators - this creates the rounded crop effect
            Item {
                id: roundDecorators
                anchors {
                    left: parent.left
                    right: parent.right
                }
                y: Theme.barHeight // Position below the bar content
                width: parent.width
                height: Theme.screenRounding

                // Left rounded corner
                Canvas {
                    id: leftCorner
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        left: parent.left
                    }
                    width: Theme.screenRounding
                    height: Theme.screenRounding

                    onPaint: {
                        var ctx = getContext("2d");
                        ctx.clearRect(0, 0, width, height);
                        ctx.fillStyle = Theme.barColor;
                        ctx.beginPath();
                        ctx.moveTo(0, 0);
                        ctx.lineTo(width, 0);
                        ctx.quadraticCurveTo(0, 0, 0, height);
                        ctx.closePath();
                        ctx.fill();
                    }

                    Component.onCompleted: requestPaint()
                    Connections {
                        target: shell
                        function onBarColorChanged() {
                            leftCorner.requestPaint();
                        }
                    }
                }

                // Right rounded corner
                Canvas {
                    id: rightCorner
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        right: parent.right
                    }
                    width: Theme.screenRounding
                    height: Theme.screenRounding

                    onPaint: {
                        var ctx = getContext("2d");
                        ctx.clearRect(0, 0, width, height);
                        ctx.fillStyle = Theme.barColor;
                        ctx.beginPath();
                        ctx.moveTo(width, 0);
                        ctx.lineTo(0, 0);
                        ctx.quadraticCurveTo(width, 0, width, height);
                        ctx.closePath();
                        ctx.fill();
                    }

                    Component.onCompleted: requestPaint()
                    Connections {
                        target: shell
                        function onBarColorChanged() {
                            rightCorner.requestPaint();
                        }
                    }
                }

                // Center fill
                Rectangle {
                    anchors {
                        left: leftCorner.right
                        right: rightCorner.left
                        top: parent.top
                        bottom: parent.bottom
                    }
                    color: "transparent"
                }

                Windows.NotificationToasts {
                    screen: bar.screen
                }
            }

            // Update timer
            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: {
                    timeText.text = Qt.formatDateTime(new Date(), "ddd, MMM d hh:mm");
                }
            }
        }

        Component.onCompleted: [Launcher.init(), Notifications.init()]
    }
}
