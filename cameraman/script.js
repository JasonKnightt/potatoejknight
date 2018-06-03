const Dashcam = new Vue({
    el: "#Dashcam_Body",

    data: {
        showDash: false,

        gameTime: 0,
        clockTime: {},
        unitName: "",

        dashMessageOne: "This vehicle is licensed to the",
        dashLabel: "Channel 69 News",
        dashMessageTwo: "Any unauthorized use is subject to heavy penalty under any and all copyright infringment laws."
    },

    methods: {

        EnableDashcam() {
            this.showDash = true;
        },

        DisableDashcam() {
            this.showDash = false;
        },

        UpdateDashcam(data) {
            this.gameTime = data.gameTime;
            this.clockTime = data.clockTime;
            };
        },

    }
});

document.onreadystatechange = () => {
    if (document.readyState === "complete") {
        window.addEventListener('message', function(event) {
            if (event.data.type == "enabledash") {
                
                Dashcam.EnableDashcam();

            } else if (event.data.type == "disabledash") {

                Dashcam.DisableDashcam();

            } else if (event.data.type == "updatedash") {

                Dashcam.UpdateDashcam(event.data.info);

            }

        });
    };
};