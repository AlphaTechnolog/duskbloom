import { Gtk } from "astal/gtk3";
import { UserService } from "../../services";
import { Variable } from "astal";
import { capitalize, iconPath } from "../../utils";

function ProfilePhoto() {
  return (
    <box
      valign={Gtk.Align.CENTER}
      halign={Gtk.Align.CENTER}
      className="profile-photo"
      heightRequest={28}
      widthRequest={28}
      css={`
        background-image: url("${UserService.instance.pfp}");
      `}
    />
  );
}

function UserName() {
  return (
    <label
      className="username"
      valign={Gtk.Align.CENTER}
      halign={Gtk.Align.START}
    >
      {`Hi ${UserService.instance.username}`}
    </label>
  );
}

function PowerOptions() {
  const handleClick = () => {
    console.log("clicked");
  };

  return (
    <button className="power-dispatcher" onClicked={handleClick}>
      <icon icon={iconPath("power")} />
    </button>
  );
}

export function PowerButtons() {
  return (
    <box hexpand homogeneous>
      <box halign={Gtk.Align.START} spacing={7}>
        <ProfilePhoto />
        <UserName />
      </box>
      <box halign={Gtk.Align.END}>
        <PowerOptions />
      </box>
    </box>
  );
}
