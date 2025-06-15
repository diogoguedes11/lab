
 const selector = document.getElementById("streamSelector");
 const player = document.getElementById("player");

    selector.addEventListener("change", () => {
      const videoId = selector.value;
      if (videoId) {
        const embedUrl = `https://www.youtube.com/embed/${videoId}?autoplay=1&mute=0`;
        player.src = embedUrl;
      }
    });
