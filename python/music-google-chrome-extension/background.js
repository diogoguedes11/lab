chrome.action.onClicked.addListener((tab) => {
  const windowWidth = 500; 
  const windowHeight = 500;

  chrome.windows.create({
    url: chrome.runtime.getURL("player.html"), 
    type: "popup", 
    width: windowWidth,
    height: windowHeight,
  });
});
