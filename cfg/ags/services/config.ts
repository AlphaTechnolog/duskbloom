import { exec, readFile, writeFile } from "astal";

export enum MonitorDisplay {
  ALL = "all",
  PRIMARY = "primary",
}

export interface ConfigSchema {
  panel: {
    showOnMonitor: MonitorDisplay;
  };
}

const DEFAULT_CONFIG: ConfigSchema = {
  panel: {
    showOnMonitor: MonitorDisplay.ALL,
  },
};

export class Config {
  private static _instance: Config | undefined = undefined;

  constructor(
    private _configDir = "duskbloom",
    private _configFile = "config.json",
  ) {}

  public static get instance(): Config {
    if (Config._instance === undefined) {
      return (Config._instance = new Config());
    }

    return Config._instance;
  }

  private get _userHome(): string {
    return exec(["bash", "-c", "echo $HOME"]);
  }

  private get _confdirpath(): string {
    return [this._userHome, ".config", this._configDir].join("/");
  }

  private get _conffilepath(): string {
    return [this._confdirpath, this._configFile].join("/");
  }

  private get _confContent(): string {
    return readFile(this._conffilepath);
  }

  private get _parsedContent(): ConfigSchema | undefined {
    const content = this._confContent;
    if (content === "") return undefined;

    try {
      return JSON.parse(content) as ConfigSchema;
    } catch {
      return undefined;
    }
  }

  public getConfig(): ConfigSchema {
    let config: ConfigSchema | undefined = undefined;
    if ((config = this._parsedContent) === undefined) {
      this._initialBootstrap();
      return (config = this._parsedContent as ConfigSchema);
    }

    return config;
  }

  private existsDir(path: string): boolean {
    return (
      exec(["bash", "-c", `test -d ${path} && echo yes || echo no`]) === "yes"
    );
  }

  private existsFile(path: string): boolean {
    return (
      exec(["bash", "-c", `test -f ${path} && echo yes || echo no`]) === "yes"
    );
  }

  private writeDefaultContent(): void {
    const conf: string = JSON.stringify(DEFAULT_CONFIG, null, 2);
    writeFile(this._conffilepath, conf);
    console.log("wrote", conf);
  }

  private _initialBootstrap() {
    const existsConfDir = this.existsDir(this._confdirpath);
    if (!existsConfDir) exec(["mkdir", "-p", this._confdirpath]);
    const existsConfFile = this.existsFile(this._conffilepath);
    if (!existsConfFile) exec(["touch", this._conffilepath]);

    if (this._parsedContent === undefined) {
      this.writeDefaultContent();
    }
  }
}
