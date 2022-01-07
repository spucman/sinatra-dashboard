function succcessCountDownChanged(dismissCountDown) {
    this.success.dismissCountDown = dismissCountDown;
    if(dismissCountDown === 0) {
        this.success.message = '';
    }
}

function errorCountDownChanged(dismissCountDown) {
    this.error.dismissCountDown = dismissCountDown;
    if(dismissCountDown === 0) {
        this.error.message = '';
    }
}

function showSuccessMessage(msg) {
    this.success.dismissCountDown = this.success.dismissSec;
    this.success.message = msg;
}

function showErrorMessage(msg) {
    this.error.dismissCountDown = this.error.dismissSec;
    this.error.message = msg;
}
