'use strict';
// Firefox MV2: browser.* は常に Promise を返す。chrome.* に上書きして統一する
if (typeof browser !== 'undefined' && typeof chrome !== 'undefined') {
  if (!browser.action && browser.browserAction) browser.action = browser.browserAction;
  Object.assign(chrome, browser);
}
