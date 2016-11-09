
const St = imports.gi.St;
const Gio = imports.gi.Gio;
const GLib = imports.gi.GLib;
const Main = imports.ui.main;
const Tweener = imports.ui.tweener;
const MessageTray = imports.ui.messageTray;

let text, button;
let originalCountUpdated, originalDestroy;

function updateMessageFile() {
    let sources = Main.messageTray.getSources();
    let fname = GLib.getenv("XDG_RUNTIME_DIR") + "/notifications";
    let file = Gio.file_new_for_path(fname);
    let fstream = file.replace(null, false, Gio.FileCreateFlags.NONE, null);

    for (let i = 0; i < sources.length; i++) {
    	for (let n = 0; n < sources[i].notifications.length; n++) {
            let data = "" + sources[i].notifications[n].title + "\n";
            fstream.write(data, null, data.length);
    	}
    }

    fstream.close(null);
}

function _countUpdated() {
    let res = originalCountUpdated.call(this);

    updateMessageFile();
    return res;
}

function _destroy() {
    let res = originalDestroy.call(this);

    updateMessageFile();
    return res;
}

function init() {
/*
    button = new St.Bin({ style_class: 'panel-button',
                          reactive: true,
                          can_focus: true,
                          x_fill: true,
                          y_fill: false,
                          track_hover: true });
    let icon = new St.Icon({ icon_name: 'system-run-symbolic',
                             style_class: 'system-status-icon' });

    button.set_child(icon);
    button.connect('button-press-event', updateMessageFile);
*/
}

function enable() {
    originalCountUpdated = MessageTray.Source.prototype.countUpdated;
    originalDestroy = MessageTray.Source.prototype.destroy;

    MessageTray.Source.prototype.countUpdated = _countUpdated;
    MessageTray.Source.prototype.destroy = _destroy;

    Main.panel._rightBox.insert_child_at_index(button, 0);
}

function disable() {
    MessageTray.Source.prototype.countUpdated = originalCountUpdated;
    MessageTray.Source.prototype.destroy = originalDestroy;

    Main.panel._rightBox.remove_child(button);
}