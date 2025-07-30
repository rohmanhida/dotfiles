pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import "../Singletons"
import "../Utils"
import Quickshell.Services.Notifications

MouseArea {
    id: toast

    required property Notification notif

    property int actionHeight: 30
    property int expansionSpeed: 100
    property int countdownTime: 1000
    property bool showTimeBar: false

    property string body
    property string appName
    property string summary
    property string appIcon

    Component.onCompleted: {
        body = notif?.body ?? "";
        appName = notif?.appName ?? "";
        summary = notif?.summary ?? "";
        appIcon = notif?.appIcon ?? "";
    }

    height: box.height
    hoverEnabled: true

    signal close

    // for copying
    TextEdit {
        id: textEdit
        visible: false
    }

    Rectangle {
        id: box
        width: parent.width
        height: header.height + actions.implicitHeight + bodyBox.height + (5 * 4)

        clip: true

        color: Theme.barColor
        radius: Theme.screenRounding

        border.color: Theme.barColor
        border.width: 3

        Item {
            id: inner
            anchors.margins: 5
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.fill: parent

            RowLayout {
                id: header
                width: parent.width
                height: 25

                IconImage {
                    source: toast.appIcon ? Quickshell.iconPath(toast.appIcon) : ""
                    height: parent.height
                    width: height
                    visible: toast.appIcon ?? false
                }

                Text {
                    text: `${toast.appIcon ? "" : `${toast.appName}:`} ${toast.summary}`
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                    font.pointSize: 10.5
                    font.family: "Inter"

                    color: Theme.textColor
                }

                Button {
                    onClicked: () => {
                        textEdit.text = toast.body;
                        textEdit.selectAll();
                        textEdit.copy();
                    }

                    IconImage {
                        anchors.fill: parent
                        source: Quickshell.iconPath("/usr/share/icons/Qogir/24/actions/editcopy.svg")
                    }
                }

                Button {
                    onClicked: toast.close()
                    IconImage {
                        anchors.fill: parent
                        source: Quickshell.iconPath("/usr/share/icons/Qogir/24/actions/window-close.svg")
                    }
                }
            }

            Rectangle {
                id: bodyBox
                width: parent.width
                anchors.top: header.bottom
                height: 60
                clip: true
                property int maxHeight: 0
                color: "transparent"
                anchors.topMargin: 4

                Text {
                    id: text
                    text: toast.body ?? ""
                    width: parent.width
                    height: parent.height
                    wrapMode: Text.Wrap
                    elide: Text.ElideRight
                    font.pointSize: 10
                    font.family: "Inter"

                    color: Theme.textColor

                    onImplicitHeightChanged: {
                        if (text.implicitHeight < bodyBox.height) {
                            bodyBox.height = text.implicitHeight;
                        }
                    }

                    Component.onCompleted: () => {
                        bodyBox.maxHeight = Qt.binding(() => text.implicitHeight);
                    }
                }

                states: State {
                    name: "expand"
                    when: toast.containsMouse
                    PropertyChanges {
                        target: bodyBox
                        height: bodyBox.maxHeight
                    }
                }

                transitions: Transition {
                    NumberAnimation {
                        properties: "height"
                        duration: toast.expansionSpeed
                    }
                }
            }

            GridLayout {
                id: actions
                width: parent.width
                anchors.top: bodyBox.bottom
                anchors.topMargin: 5
                anchors.bottomMargin: 5
                columns: toast.notif?.actions.length < 6 ? toast.notif?.actions.length : 4
                Repeater {
                    id: rep
                    model: toast.notif?.actions

                    delegate: NotificationToastAction {
                        required property var modelData
                        notifAction: modelData
                        hasIcons: toast.notif?.hasActionIcons ?? false
                        height: toast.actionHeight
                        Layout.fillWidth: true
                    }
                }
                visible: toast.notif?.actions.length ?? false
            }
        }

        NumberAnimation on width {
            duration: toast.expansionSpeed
        }

        Rectangle {
            id: timeBar
            visible: toast.showTimeBar
            anchors.margins: 2
            anchors.rightMargin: 4
            anchors.bottom: box.bottom
            anchors.right: box.right
            width: box.width - box.border.width - anchors.margins - Theme.screenRounding * 2
            height: 4

            bottomLeftRadius: box.radius
            bottomRightRadius: box.radius

            color: {
                switch (toast.notif?.urgency) {
                case NotificationUrgency.Critical:
                    return Theme.accentColor;
                    break;
                case NotificationUrgency.Normal:
                    return Theme.accentColor;
                    break;
                default:
                    return Theme.inactiveColor;
                }
            }

            clip: true

            NumberAnimation on width {
                id: anim
                from: timeBar.width
                to: 0
                duration: toast.countdownTime
                paused: toast.containsMouse && timeBar.visible
                running: timeBar.visible

                onFinished: () => {
                    toast.close();
                }
            }

            Connections {
                target: toast
                function onEntered() {
                    timeBar.width = box.width - box.border.width - timeBar.anchors.margins;
                    anim.restart();
                    anim.pause();
                }
            }
        }
    }
}
