import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import Quickshell.Widgets
import "../Utils"

Button {
    id: actionButton

    required property var notifAction
    required property bool hasIcons

    IconImage {
        visible: parent.hasIcons
        Component.onCompleted: () => {
            if (parent.hasIcons) {
                source = actionButton.notifAction?.identifier ?? "";
            }
        }
    }

    text: notifAction?.text ?? "ajg"
    onClicked: () => notifAction?.invoke()
}
