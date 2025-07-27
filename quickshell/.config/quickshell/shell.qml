import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Notifications

ShellRoot {
    id: shell

    property color barColor: "#000"
    property color textColor: "#ffffff"
    property color accentColor: "#7c3aed"
    property color inactiveColor: "#6b7280"
    property int screenRounding: 16
    property int barHeight: 32

    // Notification state management
    property bool notificationPanelOpen: false
    property int unreadNotifications: 0

    // Notification server
    NotificationServer {
        id: notifServer
        actionIconsSupported: true
        actionsSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: false
        bodySupported: true
        imageSupported: true

        onNotification: n => {
            n.tracked = true;

            notif.incomingAdded(n);

            Timer.after(1000, notif, () => {
                notif.incomingRemoved(n.id);
            });
        }
    }

    property alias list: notifServer.trackedNotifications

    signal incomingRemoved(id: int)
    signal incomingAdded(id: Notification)

    // Debug: Log notification system status
    Component.onCompleted: {
        console.log("QuickShell Notification System initialized");
        console.log("NotificationServer available:", typeof notifServer !== 'undefined');
        if (typeof notifServer !== 'undefined') {
            console.log("Current notifications count:", notifServer.notification.length);
        }
    }

    PanelWindow {
        id: bar

        anchors {
            left: true
            right: true
            top: true
        }

        // Bar window is taller to accommodate the rounded decoration
        implicitHeight: barHeight + screenRounding

        color: "transparent"

        Item {
            id: barContent
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }
            height: shell.barHeight

            // Main bar background
            Rectangle {
                id: barBackground
                anchors.fill: parent
                color: shell.barColor
                // No radius on the bar itself - it's straight
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                spacing: 0

                // Left section - Workspaces
                Row {
                    Layout.fillWidth: false
                    spacing: 8
                    Layout.alignment: Qt.AlignVCenter

                    Repeater {
                        model: 10

                        delegate: Rectangle {
                            property bool isActive: Hyprland.focusedWorkspace && Hyprland.focusedWorkspace.id === (index + 1)
                            property bool hasWindows: {
                                var workspace = Hyprland.workspaces.find(ws => ws.id === (index + 1));
                                return workspace && workspace.windows && workspace.windows.length > 0;
                            }

                            width: 6
                            height: 6
                            radius: 3

                            color: {
                                if (isActive) {
                                    return shell.textColor;
                                } else if (hasWindows) {
                                    return shell.inactiveColor;
                                } else {
                                    return Qt.rgba(shell.inactiveColor.r, shell.inactiveColor.g, shell.inactiveColor.b, 0.3);
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

                // Center spacer
                Item {
                    Layout.fillWidth: true
                }

                // Right section - Notifications + Time
                Row {
                    Layout.fillWidth: false
                    spacing: 12
                    Layout.alignment: Qt.AlignVCenter

                    // Notification indicator
                    Rectangle {
                        id: notificationIndicator
                        width: 20
                        height: 20
                        radius: 10
                        color: shell.notificationPanelOpen ? shell.accentColor : (shell.unreadNotifications > 0 ? shell.textColor : shell.inactiveColor)
                        opacity: shell.unreadNotifications > 0 || shell.notificationPanelOpen ? 1.0 : 0.4

                        Behavior on color {
                            ColorAnimation {
                                duration: 150
                            }
                        }

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 150
                            }
                        }

                        Text {
                            anchors.centerIn: parent
                            text: shell.unreadNotifications > 9 ? "9+" : (shell.unreadNotifications > 0 ? shell.unreadNotifications.toString() : "󰂚")
                            color: shell.notificationPanelOpen ? shell.barColor : shell.barColor
                            font.pixelSize: shell.unreadNotifications > 0 ? 9 : 12
                            font.weight: Font.Bold
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: shell.notificationPanelOpen = !shell.notificationPanelOpen
                        }
                    }

                    Text {
                        id: timeText
                        text: Qt.formatTime(new Date(), "h:mm AP")
                        color: shell.textColor
                        font.pixelSize: 13
                        font.weight: Font.Medium
                    }
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
            y: shell.barHeight // Position below the bar content
            width: parent.width
            height: shell.screenRounding

            // Left rounded corner
            Canvas {
                id: leftCorner
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                }
                width: shell.screenRounding
                height: shell.screenRounding

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.clearRect(0, 0, width, height);
                    ctx.fillStyle = shell.barColor;
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
                width: shell.screenRounding
                height: shell.screenRounding

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.clearRect(0, 0, width, height);
                    ctx.fillStyle = shell.barColor;
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
        }

        // Update timer
        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: {
                timeText.text = Qt.formatTime(new Date(), "h:mm AP");
            }
        }
    }

    // Notification popup overlay
    Repeater {
        id: notificationPopups
        model: notifServer.notification

        delegate: Loader {
            id: popupLoader
            property var notification: modelData
            property int notificationIndex: index

            active: notification && !notification.dismissed

            sourceComponent: PanelWindow {
                id: notificationPopup

                anchors {
                    top: true
                    right: true
                }

                width: 350
                height: Math.min(120, notificationContent.implicitHeight + 20)

                margins {
                    top: 60 + (popupLoader.notificationIndex * (height + 10))
                    right: 20
                }

                color: "transparent"
                visible: true

                // Debug
                Component.onCompleted: {
                    console.log("Notification popup created for:", popupLoader.notification.summary);
                }

                Rectangle {
                    id: popupBackground
                    anchors.fill: parent
                    color: shell.barColor
                    radius: 12
                    border.width: 1
                    border.color: Qt.rgba(shell.textColor.r, shell.textColor.g, shell.textColor.b, 0.1)

                    // Subtle shadow
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: -1
                        color: "transparent"
                        radius: parent.radius + 1
                        border.width: 1
                        border.color: Qt.rgba(0, 0, 0, 0.3)
                        z: -1
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            console.log("Popup clicked");
                            if (popupLoader.notification.actions && popupLoader.notification.actions.length > 0) {
                                popupLoader.notification.actions[0].invoke();
                            }
                            popupLoader.notification.dismiss();
                        }
                    }

                    RowLayout {
                        id: notificationContent
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 12

                        // App icon
                        Rectangle {
                            Layout.preferredWidth: 40
                            Layout.preferredHeight: 40
                            Layout.alignment: Qt.AlignTop
                            color: shell.accentColor
                            radius: 8

                            Text {
                                anchors.centerIn: parent
                                text: popupLoader.notification.appName ? popupLoader.notification.appName.charAt(0).toUpperCase() : "N"
                                color: "white"
                                font.pixelSize: 18
                                font.weight: Font.Bold
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: 4

                            // Title
                            Text {
                                Layout.fillWidth: true
                                text: popupLoader.notification.summary || "Notification"
                                color: shell.textColor
                                font.pixelSize: 14
                                font.weight: Font.Bold
                                elide: Text.ElideRight
                                maximumLineCount: 1
                            }

                            // Body
                            Text {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                text: popupLoader.notification.body || ""
                                color: Qt.rgba(shell.textColor.r, shell.textColor.g, shell.textColor.b, 0.8)
                                font.pixelSize: 12
                                wrapMode: Text.WordWrap
                                elide: Text.ElideRight
                                maximumLineCount: 3
                            }

                            // Timestamp
                            Text {
                                Layout.fillWidth: true
                                text: Qt.formatTime(new Date(), "hh:mm")
                                color: shell.inactiveColor
                                font.pixelSize: 10
                                horizontalAlignment: Text.AlignRight
                            }
                        }

                        // Close button
                        Rectangle {
                            Layout.preferredWidth: 24
                            Layout.preferredHeight: 24
                            Layout.alignment: Qt.AlignTop
                            color: Qt.rgba(shell.textColor.r, shell.textColor.g, shell.textColor.b, 0.1)
                            radius: 12

                            Text {
                                anchors.centerIn: parent
                                text: "✕"
                                color: shell.textColor
                                font.pixelSize: 12
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    console.log("Close button clicked");
                                    popupLoader.notification.dismiss();
                                }
                            }
                        }
                    }
                }

                // Auto-dismiss timer
                Timer {
                    interval: 5000
                    running: true
                    onTriggered: {
                        console.log("Auto-dismissing notification");
                        popupLoader.notification.dismiss();
                    }
                }

                // Slide-in animation
                PropertyAnimation {
                    target: notificationPopup
                    property: "margins.right"
                    from: -notificationPopup.width
                    to: 20
                    duration: 300
                    easing.type: Easing.OutCubic
                    running: true
                }
            }
        }
    }

    // Notification Center Panel
    PanelWindow {
        id: notificationCenter
        visible: shell.notificationPanelOpen

        anchors {
            top: true
            right: true
        }

        implicitWidth: 400
        implicitHeight: 600

        margins {
            top: shell.barHeight + shell.screenRounding + 10
            right: 20
        }

        color: "transparent"

        Rectangle {
            id: centerBackground
            anchors.fill: parent
            color: shell.barColor
            radius: 16
            border.width: 1
            border.color: Qt.rgba(shell.textColor.r, shell.textColor.g, shell.textColor.b, 0.1)

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 15

                // Header
                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: "Notifications"
                        color: shell.textColor
                        font.pixelSize: 18
                        font.weight: Font.Bold
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        Layout.preferredWidth: 80
                        Layout.preferredHeight: 28
                        color: Qt.rgba(shell.textColor.r, shell.textColor.g, shell.textColor.b, 0.1)
                        radius: 14

                        Text {
                            anchors.centerIn: parent
                            text: "Clear All"
                            color: shell.textColor
                            font.pixelSize: 11
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                notifServer.clearHistory();
                                shell.unreadNotifications = 0;
                            }
                        }
                    }
                }

                // Notifications list
                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: notifServer.notification
                    spacing: 10
                    clip: true

                    // Custom scrollbar
                    Rectangle {
                        id: scrollbar
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.rightMargin: 2
                        width: 4
                        color: Qt.rgba(shell.textColor.r, shell.textColor.g, shell.textColor.b, 0.2)
                        radius: 2
                        visible: parent.contentHeight > parent.height

                        Rectangle {
                            width: parent.width
                            height: Math.max(20, parent.height * (parent.parent.height / parent.parent.contentHeight))
                            y: parent.height * (parent.parent.contentY / (parent.parent.contentHeight - parent.parent.height))
                            color: Qt.rgba(shell.textColor.r, shell.textColor.g, shell.textColor.b, 0.5)
                            radius: parent.radius
                        }
                    }

                    delegate: Rectangle {
                        width: ListView.view.width - 10
                        height: Math.max(60, notificationItemContent.implicitHeight + 20)
                        color: Qt.rgba(shell.textColor.r, shell.textColor.g, shell.textColor.b, 0.05)
                        radius: 12

                        RowLayout {
                            id: notificationItemContent
                            anchors.fill: parent
                            anchors.margins: 15
                            spacing: 12

                            Rectangle {
                                Layout.preferredWidth: 35
                                Layout.preferredHeight: 35
                                Layout.alignment: Qt.AlignTop
                                color: shell.accentColor
                                radius: 6

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.appName ? modelData.appName.charAt(0).toUpperCase() : "N"
                                    color: "white"
                                    font.pixelSize: 14
                                    font.weight: Font.Bold
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 3

                                Text {
                                    Layout.fillWidth: true
                                    text: modelData.summary || "Notification"
                                    color: shell.textColor
                                    font.pixelSize: 13
                                    font.weight: Font.Medium
                                    elide: Text.ElideRight
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: modelData.body || ""
                                    color: Qt.rgba(shell.textColor.r, shell.textColor.g, shell.textColor.b, 0.7)
                                    font.pixelSize: 11
                                    wrapMode: Text.WordWrap
                                    elide: Text.ElideRight
                                    maximumLineCount: 2
                                }

                                Text {
                                    text: Qt.formatDateTime(modelData.time, "MMM dd, hh:mm")
                                    color: shell.inactiveColor
                                    font.pixelSize: 9
                                }
                            }

                            Rectangle {
                                Layout.preferredWidth: 20
                                Layout.preferredHeight: 20
                                Layout.alignment: Qt.AlignTop
                                color: Qt.rgba(shell.textColor.r, shell.textColor.g, shell.textColor.b, 0.1)
                                radius: 10

                                Text {
                                    anchors.centerIn: parent
                                    text: "✕"
                                    color: shell.textColor
                                    font.pixelSize: 10
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: modelData.dismiss()
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (modelData.actions && modelData.actions.length > 0) {
                                    modelData.actions[0].invoke();
                                }
                            }
                        }
                    }
                }
            }
        }

        // Click outside to close
        MouseArea {
            anchors.fill: parent
            z: -1
            onClicked: shell.notificationPanelOpen = false
        }
    }

    // Test button (temporary - remove after testing)
    Rectangle {
        id: testButton
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 20
        width: 120
        height: 40
        color: shell.accentColor
        radius: 8
        z: 1000
        visible: true

        Text {
            anchors.centerIn: parent
            text: "Test Notify"
            color: "white"
            font.pixelSize: 12
            font.weight: Font.Bold
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("Test button clicked!");
                shell.unreadNotifications++;
                shell.notificationPanelOpen = true;
                console.log("Unread notifications:", shell.unreadNotifications);
            }
        }
    }

    // Update notification count
    Connections {
        target: notifServer
        function onNotificationReceived(notification) {
            console.log("Notification received:", notification.summary);
            shell.unreadNotifications++;
        }
        function onNotificationDismissed() {
            console.log("Notification dismissed");
            if (shell.unreadNotifications > 0) {
                shell.unreadNotifications--;
            }
        }
    }

    // Fallback test notifications (for testing purposes)
    property var testNotifications: [
        {
            summary: "Test Notification 1",
            body: "This is a test notification to verify the system works",
            appName: "QuickShell",
            time: new Date(),
            actions: [],
            dismiss: function () {
                console.log("Test notification 1 dismissed");
            }
        },
        {
            summary: "Another Test",
            body: "Second test notification with longer text to see how it wraps and displays in the notification center",
            appName: "Test",
            time: new Date(),
            actions: [],
            dismiss: function () {
                console.log("Test notification 2 dismissed");
            }
        }
    ]

    // Test button (temporary - remove after testing)
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 20
        width: 120
        height: 40
        color: shell.accentColor
        radius: 8
        z: 1000

        Text {
            anchors.centerIn: parent
            text: "Test Notify"
            color: "white"
            font.pixelSize: 12
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("Adding test notification");
                shell.unreadNotifications++;
                // You can manually trigger the notification panel to test
                shell.notificationPanelOpen = true;
            }
        }
    }
}
