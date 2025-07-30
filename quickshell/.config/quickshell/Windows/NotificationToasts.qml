import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

import "../Singletons" as Singletons
import "../Modules"

PanelWindow {
    id: window

    WlrLayershell.namespace: "notifications"
    exclusionMode: ExclusionMode.Normal
    color: "transparent"
    implicitWidth: 500

    mask: Region {
        intersection: Intersection.Combine
        x: 30
        y: 30
        height: popups.contentHeight
        width: window.width - 60
    }

    anchors {
        left: true
        top: true
        bottom: true
    }

    visible: popups.children
    onVisibleChanged: () => { print(`visible: ${visible}, popup count: ${popups.children.length}`) }

    HyprlandWindow.visibleMask: window.mask

    MouseArea {
        id: mouseArea
        hoverEnabled: true
        anchors.fill: parent

        ListView {
            id: popups
            anchors.margins: 30
            anchors.fill: parent
            focus: true
            spacing: 10

            model: ListModel {
                id: data
                Component.onCompleted: () => {
                    Singletons.Notifications.incomingAdded.connect(n => {
                        data.insert(0, {
                            notif: n
                        });
                    });
                    Singletons.Notifications.incomingRemoved.connect(n => {
                        for(let i = 0; i < data.count; i++)
                        {
                            let elem = data.get(i);
                            if(elem.id == n) {
                                elem.visible = false;
                                return;
                            }
                        }
                    });
                }
            }
            addDisplaced: Transition { 
                NumberAnimation {
                    properties: "x,y"
                    duration: 100
                }
            }
            add: Transition {
                NumberAnimation {
                    properties: "y"
                    from: -50
                    duration: 100
                }
            }
            remove: Transition {
                PropertyAction {
                    property: "ListView.delayRemove"
                    value: true
                }
                ParallelAnimation {
                    NumberAnimation {
                        property: "opacity"
                        to: 0
                        duration: 200
                    }
                    NumberAnimation {
                        properties: "y"
                        to: -100
                        duration: 200
                    }
                }
                PropertyAction {
                    property: "ListView.delayRemove"
                    value: true
                }
            }

            delegate: NotificationToast {
                id: toast

                property int totalCountdownTime: 5000
                countdownTime: totalCountdownTime

                required property int index

                width: ListView.view.width
                showTimeBar: true

                onEntered: () => { countdownTime = totalCountdownTime }

                Component.onCompleted: notif.closed.connect(() => {
                    close()
                })

                onClose: {
                    if(!toast || toast.index < 0)
                        return;

                    ListView.view.model.remove(toast.index, 1);
                }
            }
        }
    }
}
