type ClientEnv = typeof import("astro:env/client");

interface Window {
  postServer(
    url: string,
    opts?: { headers?: Record<string, string>; body?: any; method?: string }
  ): Promise<any>;
}

declare namespace JSX {
  interface IntrinsicElements {
    "md-elevated-card": any;
    "md-outlined-card": any;
    "md-assist-chip": any;
    "md-icon-button": any;
    "md-outlined-text-field": any;
    "md-outlined-select": any;
    "md-select-option": any;
    "md-filled-button": any;
    "md-text-button": any;
    "md-outlined-button": any;
    "md-divider": any;
  }
}

