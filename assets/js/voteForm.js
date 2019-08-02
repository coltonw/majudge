// depends on vue js
const vueData = {};

document.querySelectorAll('[data-candidate]').forEach((el) => {
    vueData[`rating${el.getAttribute('data-candidate')}`] = false;
});

const vue = new Vue({
    el: '#app',
    data: vueData,
})