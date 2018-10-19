var messageTimer = setInterval(sendPeriodicMessage, 30000);

function sendPeriodicMessage() {
    safari.extension.dispatchMessage("NoGoofingOffTimerSafariExtPeriodicMessage");
}
