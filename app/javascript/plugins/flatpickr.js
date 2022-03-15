import flatpickr from "flatpickr";

const initFlatpickr = () => {
  let flat = document.querySelector(".flatpickr")

  if (flat) {
    flatpickr(flat, {
      disableMobile: true,
      dateFormat: "d/m/Y",
      defaultDate: "today"
    })
  }
};

export { initFlatpickr };
