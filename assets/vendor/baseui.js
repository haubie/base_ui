// import echarts from '../vendor/echarts';
// import * as echarts from '../vendor/echarts/core';


function scrollCarousel(elId) {
    var theEl = window.document.getElementById(elId);
    theEl.scrollIntoView({behavior: "smooth", block: "nearest", inline: "nearest"});
  }

// function initChart(elId) {
//     let chartEl = document.getElementById(elId);
//     return echarts.init(chartEl);
// }


export default {
    scrollCarousel
};