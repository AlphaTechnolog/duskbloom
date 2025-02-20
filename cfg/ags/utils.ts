import { exec } from "astal";
import { App, Gdk } from "astal/gtk3";
import { ConfigService } from "./services";

export const getClassList = (wdgt: any): string[] => {
  return wdgt.get_class_name().split(" ");
};

export const hasClassName = (wdgt: any, className: string): boolean => {
  return getClassList(wdgt).includes(className);
};

export const toggleClass = (wdgt: any, className: string) => {
  let classlist = getClassList(wdgt);

  if (classlist.includes(className)) {
    classlist.splice(classlist.indexOf(className), 1);
  } else {
    classlist.push(className);
  }

  wdgt.set_class_name(classlist.join(" "));
};

export const addClassIf = (
  wdgt: any,
  assertion: boolean,
  classname: string,
): void => {
  const classlist = getClassList(wdgt);

  if (assertion && !classlist.includes(classname)) {
    classlist.push(classname);
  } else if (!assertion && classlist.includes(classname)) {
    classlist.splice(classlist.indexOf(classname), 1);
  }

  wdgt.set_class_name(classlist.join(" "));
};

export const getPrimaryMonitor = (): Gdk.Monitor => {
  const display = Gdk.Display.get_default();

  let primaryMonitor: Gdk.Monitor | null | undefined;
  if (!Boolean((primaryMonitor = display?.get_primary_monitor()))) {
    // return the first monitor if there's no primary monitor
    // acquired by the system.
    return App.get_monitors()[0]!;
  }

  return primaryMonitor!;
};

export const getEnv = (envvar: string): string => {
  return exec(["bash", "-c", `echo $${envvar}`]);
};

export const getHome = (): string => getEnv("HOME");

// TODO: Figure out a better way to obtain the config path.
export const iconPath = (name: string): string => {
  const confDir = [getHome(), ".config", "ags"].join("/");
  const path = [confDir, "icons"];
  if (ConfigService.instance.getConfig().palette.darkMode) {
    path.push("dark");
  } else {
    path.push("light");
  }
  return [...path, `${name}.svg`].join("/");
};

export const existsDir = (dirname: string): boolean => {
  return (
    exec(["bash", "-c", `test -d ${dirname} && echo yes || echo no`]) === "yes"
  );
};

export const existsFile = (filename: string): boolean => {
  return (
    exec(["bash", "-c", `test -f ${filename} && echo yes || echo no`]) === "yes"
  );
};

export const capitalize = (text: string): string => {
  return text.charAt(0).toUpperCase() + text.slice(1).toLowerCase();
};
