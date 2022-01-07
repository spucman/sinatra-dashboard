//= require messages.js

function onPrev(event) {
    event.preventDefault();
    if(this.week - 1 < 1 ) {
        this.week = 52;
        this.year--;
    } else {
        this.week--;
    }
}
  
function onNext(event) {
    event.preventDefault();
    if(this.week + 1 > 52 ) {
        this.week = 1;
        this.year++;
    } else {
        this.week++;
    }
}

function onMailSend(event) {
    event.preventDefault();
    this.$bvModal.show('sendMailModal');
}

function onMailSendSubmit(event) {
    event.preventDefault();
    
    let email = this.$refs.sendTo.value.trim();
    let requestOptions = {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ 
            'email': email, 
            'week': this.week, 
            'year': this.year, 
            'user': this.selectedUser
        })
    };

    fetch('/rest/v1/report/weekly/preview/send', requestOptions)
        .then(response => {
            if (response.ok) {
                this.showSuccessMessage(`Successfully send email to ${email}`);
            } else if (response.status === 401 || response.status === 403) {
                this.$refs.form.submit();
            } else {
                this.showErrorMessage(`Unable to send email to ${email}: ${response.status}`);
            }
        })
        .catch(error => {
            this.showErrorMessage('Unable to send email to ${email} - see the console for more information');
            console.error('There was an error!', error);
        })
        .finally(() => { 
            this.$nextTick(() => {
                this.$bvModal.hide('sendMailModal');
            })
        });
}
