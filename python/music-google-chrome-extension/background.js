chrome.action.onClicked.addListener((tab) => {
  const windowWidth = 300; 
  const windowHeight = 200;

  chrome.windows.create({
    url: chrome.runtime.getURL("player.html"), 
    type: "popup", 
    width: windowWidth,
    height: windowHeight,
  });
});
