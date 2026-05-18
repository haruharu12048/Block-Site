// Firefox MV2: browser.* は常に Promise を返すが chrome.* は不安定
// chrome を browser に差し替えて全 API を Promise-based に統一する
if (typeof browser !== 'undefined') {
  // browser.action は MV3 のみ。MV2 では browser.browserAction を使う
  if (!browser.action && browser.browserAction) {
    browser.action = browser.browserAction;
  }
  globalThis.chrome = browser;
}
