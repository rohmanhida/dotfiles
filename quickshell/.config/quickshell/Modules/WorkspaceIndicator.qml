Rectangle {
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
                    onClicked: Hyprland.dispatch(`workspace ${(index + 1).toString()}`)
                }
            }
        }
    }
}
