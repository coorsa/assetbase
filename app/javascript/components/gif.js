const giphy = () => {
  const noChart = document.getElementById("gif-button")
  if (noChart) {
    noChart.addEventListener('click', () => {
      noChart.innerHTML = " "
      noChart.style.padding = "0 0"
      noChart.style.backgroundColor = 'transparent';
      let gifName = `${noChart.dataset.name}-NFT`
      fetch(`https://api.giphy.com/v1/gifs/search?api_key=h5bMAcEFXWItwLdyz524SCmp4f27ipTM&q=${gifName}&limit=25&offset=0&rating=g&lang=en`)
        .then(response => response.json()).then((data) => {
          noChart.insertAdjacentHTML('beforeend', `<img src=${data.data[0].images.fixed_width.url}>`)
        });
    });
  }
}
export { giphy };
