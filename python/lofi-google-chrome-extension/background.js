chrome.action.onClicked.addListener((tab) => {
  const windowWidth = 400; 
  const windowHeight = 600;

  chrome.windows.create({
    url: chrome.runtime.getURL("player.html"), 
    type: "popup", 
    width: windowWidth,
    height: windowHeight,
  });
});

 const selector = document.getElementById("streamSelector");
 const player = document.getElementById("lofiPlayer");

    selector.addEventListener("change", () => {
      const videoId = selector.value;
      if (videoId) {
        const embedUrl = `https://www.youtube.com/embed/${videoId}?autoplay=1&mute=0`;
        player.src = embedUrl;
      }
    });