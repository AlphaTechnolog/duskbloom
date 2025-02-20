import { Gtk } from "astal/gtk3";
import { iconPath } from "../../utils";

export function GithubNotifsPanel() {
  return (
    <box className="github-notifs-panel" vertical spacing={7}>
      <box homogeneous hexpand valign={Gtk.Align.START} className="header">
        <box spacing={6} halign={Gtk.Align.START}>
          <icon className="icon" icon={iconPath("github")}></icon>
          <label className="title">Github</label>
        </box>
        <button className="help" halign={Gtk.Align.END}>
          <icon icon={iconPath("help")} />
        </button>
      </box>
      <box expand vertical spacing={6}>
        <box
          expand
          valign={Gtk.Align.CENTER}
          halign={Gtk.Align.CENTER}
          spacing={10}
          vertical
          className="not-configured-container"
        >
          <label className="nf-icon github-icon"></label>
          <label valign={Gtk.Align.CENTER} halign={Gtk.Align.CENTER} expand>
            No API key configured yet.
          </label>
        </box>
      </box>
    </box>
  );
}
