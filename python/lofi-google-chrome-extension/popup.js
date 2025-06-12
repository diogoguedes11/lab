const playlist = [{
     title: "Lofi synthwave radio",
     url: "https://www.youtube.com/watch?v=4xDzrJKXOOY",
     thumbnail: "https://i.ytimg.com/vi/4xDzrJKXOOY/hqdefault.jpg"
     }, {
     title: "Lofi Girl",
     url: "https://www.youtube.com/watch?v=jfKfPfyJRdk",
     thumbnail: "https://i.ytimg.com/vi/jfKfPfyJRdk/hqdefault.jpg"
     }, {
     title: "Lofi Hip Hop Radio",
     url: "https://www.youtube.com/watch?v=jfKfPfyJRdk",
     thumbnail: "https://i.ytimg.com/vi/jfKfPfyJRdk/hqdefault.jpg"
}]


function loadPlaylist() {
     const playlistElement = document.getElementById('playlist');
     playlist.forEach(item => {
          const listItem=  document.createElement('li');
          listItem.innerHTML = `
               <a href="${item.url}" target="_blank">
                    <img src="${item.thumbnail}" alt="${item.title}" style="width: 100px; height: 100px;">
                    <p>${item.title}</p>
               </a>
          `;
          playlistElement.appendChild(listItem);
     })
}

loadPlaylist();