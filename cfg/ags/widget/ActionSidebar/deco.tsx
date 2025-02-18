import { Variable } from "astal";
import { Gtk } from "astal/gtk3";

const SECOND = 1000;

export function EyecandyHour() {
  type Hour = {
    hour: number;
    minutes: number;
  };

  const DOTS_AMOUNT = 2;
  const { START, CENTER } = Gtk.Align;

  const dateCmd = ["bash", "-c", "date '+%H:%M'"];

  const processTime = (out: string): Hour => {
    const [hour, minutes] = out.split(":").map((x) => Number(x));
    return { hour, minutes };
  };

  const hour = Variable<Hour>({ hour: 0, minutes: 0 }).poll(
    1 * SECOND,
    dateCmd,
    processTime,
  );

  const fmtNum = (n: number): string => {
    if (n >= 10) return String(n);
    return `0${n}`;
  };

  return (
    <box
      className="eyecandy-hour-container"
      valign={START}
      halign={CENTER}
      spacing={12}
    >
      <label className="hour">{hour((x) => fmtNum(x.hour))}</label>
      <box className="separator-container" vertical valign={CENTER} spacing={8}>
        {Array.from({ length: DOTS_AMOUNT }).map(() => (
          <box halign={CENTER} valign={CENTER} />
        ))}
      </box>
      <label className="minutes">{hour((x) => fmtNum(x.minutes))}</label>
    </box>
  );
}

export function EyecandyWeekdays() {
  const weekdays: string[] = ["s", "m", "t", "w", "t", "f", "s"] as const;

  type DateInfo = {
    todayNumber: number;
    weekdayIndex: number;
  };

  type WeekdayLabel = keyof typeof weekdays;
  type WeekRecords = Record<number, WeekdayLabel>;
  type Weekinfo = { records: WeekRecords; dateInfo: DateInfo };

  // normal `for` *ftw*.
  const weekinfo = Variable<Partial<Weekinfo>>({}).poll(
    60 * SECOND,
    ["bash", "-c", "date '+%d:%w'"],
    (out: string) => {
      const [todayNumber, weekdayIndex] = out.split(":").map((x) => Number(x));

      let result: Record<number, WeekdayLabel> = {};

      // populate from today to zero.
      for (let i = weekdayIndex, j = 0; i >= 0; --i, ++j) {
        result[todayNumber - j] = weekdays[i] as WeekdayLabel;
      }

      // populate from today to weekdays end.
      for (let i = weekdayIndex, j = 0; i <= weekdays.length - 1; ++i, ++j) {
        result[todayNumber + j] = weekdays[i] as WeekdayLabel;
      }

      return {
        records: result,
        dateInfo: {
          todayNumber,
          weekdayIndex,
        },
      };
    },
  );

  const getWeekdayItemClassname = (
    dateinfo: DateInfo | undefined,
    day: string,
  ): string => {
    if (!Boolean(dateinfo)) return "weekday-item";

    return [
      "weekday-item",
      dateinfo?.todayNumber === Number(day) ? "active" : "",
    ].join(" ");
  };

  return (
    <box
      className="eyecandy-weekdays-container"
      spacing={6}
      halign={Gtk.Align.CENTER}
    >
      {weekinfo((info) =>
        Object.entries(info.records ?? []).map(([day, label]) => (
          <box
            vertical
            spacing={4}
            className={getWeekdayItemClassname(info.dateInfo, day)}
          >
            <label className="label-header">{label}</label>
            <label className="day-value">{day}</label>
          </box>
        )),
      )}
    </box>
  );
}
