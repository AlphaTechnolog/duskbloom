import { Gtk } from "astal/gtk3";

export function MusicControl() {
  const handleVolumeDrag = ({ value }: { value: number }) => {
    console.log({ value });
  };

  return (
    <box className="music-control-container">
      <box expand className="card-container">
        <label valign={Gtk.Align.CENTER} halign={Gtk.Align.CENTER}>
          hello world
        </label>
      </box>
      <box vexpand className="volume-control-container">
        <slider
          vertical
          vexpand
          widthRequest={10}
          max={100}
          value={45}
          onDragged={handleVolumeDrag}
        />
      </box>
    </box>
  );
}
