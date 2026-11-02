import type { Plugin } from "vite";

/**
 * Typst's HTML export writes math accents as combining marks, for example
 *
 *   <mover accent="true"><mi>𝐷</mi><mo>̃</mo></mover>
 *
 * A combining mark has a zero-width box, so browsers center that empty box on
 * the base and draw the ink to its left: `tilde(D)` ends up on the left
 * shoulder of the `D` instead of above it. Swapping in the matching spacing
 * glyph gives the accent a real advance width, which the browser can center.
 *
 * The remaining vertical correction lives in `src/styles/global.css`, next to
 * the rest of the MathML styling.
 */
const spacingAccents: Record<string, string> = {
  "\u0300": "\u02CB", // grave
  "\u0301": "\u00B4", // acute
  "\u0302": "\u02C6", // circumflex
  "\u0303": "\u223C", // tilde
  "\u0304": "\u00AF", // macron
  "\u0306": "\u02D8", // breve
  "\u0307": "\u02D9", // dot above
  "\u0308": "\u00A8", // diaeresis
  "\u030A": "\u02DA", // ring above
  "\u030C": "\u02C7", // caron
  "\u20D6": "\u2190", // left arrow above
  "\u20D7": "\u2192", // right arrow above
};

const accentPattern = /<mo(\s[^>]*)?>([\u0300-\u036F\u20D0-\u20FF])<\/mo>/g;

/** Rewrites the accents in the HTML that `astro-typst` embeds in `.typ` modules. */
export function mathmlAccents(): Plugin {
  return {
    name: "mathml-accents",
    enforce: "post",
    transform(code, id) {
      if (!id.includes(".typ") || !code.includes("<mo")) return null;
      return {
        code: code.replace(
          accentPattern,
          (match, attrs: string | undefined, mark: string) => {
            const spacing = spacingAccents[mark];
            return spacing === undefined
              ? match
              : `<mo${attrs ?? ""}>${spacing}</mo>`;
          },
        ),
        map: null,
      };
    },
  };
}
