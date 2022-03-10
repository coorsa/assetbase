import flatpickr from "flatpickr";

const initFlatpickr = () => {
  let flat = document.querySelector(".flatpickr")

  if (flat) {
    flat.value = "";
    flatpickr(flat, {
      disableMobile: true,
      dateFormat: "d/m/Y",
    })
  }
};

export { initFlatpickr };
