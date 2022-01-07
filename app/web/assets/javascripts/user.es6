//= require messages.js

function search(event) {
    event.preventDefault();
    let searchValue = this.$refs.search.value;
    let searchTerms = searchValue.trim().split(',');

    if (!searchTerms || !searchTerms[0]) {
        this.$refs.search.value = '';
        return;
    }

    if (searchTerms.length == 1) {
        let requestOptions = {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ 'searchTerm': searchValue })
        };

        fetch('/rest/v1/user/search', requestOptions)
            .then(response => {
                if (response.ok) {
                    return response.json();
                } else if (response.status === 401 || response.status === 403) {
                    this.$refs.form.submit();
                } else {
                    this.showErrorMessage(`Unable to display search results - the server has returned: ${response.status}`);
                }
            })
            .then(json => {
                this.user = json[0];
            })
            .catch(error => {
                this.showErrorMessage('Unable to search for user - see the console for more information');
                console.error('There was an error!', error);
            });
    } else if (searchTerms.length > 1) {
        this.$refs.form.submit();
    } else {
        this.$refs.search.value = '';
    }
}

function refreshWG(oldUser, newUser) {
    this.workingGroups = []

    let userId = oldUser.user_id;
    let shouldLoad = true;
    if (newUser.user_id) {
        userId = newUser.user_id;
        if (!newUser.role_name) {
            shouldLoad = false;
        }
    } else {
        if (!oldUser.role_name) {
            shouldLoad = false;
        }
    }

    if (shouldLoad) {
        fetch(`/rest/v1/user/${userId}/wg`)
            .then(response => {
                if (response.ok) {
                    return response.json();
                } else if (response.status === 401) {
                    this.$refs.form.submit();
                } else {
                    this.showErrorMessage(`Unable to load working groups - the server has returned: ${response.status}`);
                }
            })
            .then(json => {
                this.workingGroups = json;
            })
            .catch(error => {
                this.showErrorMessage('Unable to load working groups - see the console for more information');
                console.error('There was an error!', error);
            });
    }
}

function sendCallToServerWithConfirmationBox(options) {
    const h = this.$createElement;
    const messageVNode = h('span', { domProps: { innerHTML: options.confirmMsg } });

    this.$bvModal.msgBoxConfirm([messageVNode], {
        title: options.confirmTitle,
        okTitle: 'Yes',
        cancelTitel: 'No',
        centered: true
    })
        .then(value => {
            if (value) {
                let requestOptions = (options.method === 'POST') ? {
                    method: 'POST',
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify(options.reqBody)
                } : {
                    method: 'GET'
                }

                return fetch(options.uri, requestOptions)
                    .then(response => {
                        if (response.ok) {
                            let body = response.json();
                            if (body['error']) {
                                this.showErrorMessage(`${options.errorMsg} - ${body['error']}`);
                            } else {
                                this.showSuccessMessage(options.successMsg);
                            }
                        } else if (response.status === 401) {
                            location.reload();
                        } else {
                            this.showErrorMessage(`${options.errorMsg} - the server has returned: ${response.status}`);
                        }
                    });
            }
        })
        .catch(err => {
            this.showErrorMessage(`${options.errorMsg} - see the console for more information`);
            console.error('There was an error!', error);
        });
}

function activateUser() {
    this.sendCallToServerWithConfirmationBox({
        confirmTitle: 'Confirm User Activation',
        confirmMsg: `Are you sure you want to activate the user: <strong>${this.user.email}</strong>?`,
        uri: '/rest/v1/user/activate',
        method: 'POST',
        reqBody: { 'email': this.user.email },
        successMsg: `The user ${this.user.email} has been activated.`,
        errorMsg: 'The user activation failed',
    });
}

function sendResetPasswordEmail() {
    this.sendCallToServerWithConfirmationBox({
        confirmTitle: 'Confirm sending Reset Password Email',
        confirmMsg: `Are you sure you want to send a reset password email to <strong>${this.user.email}</strong>?`,
        uri: '/rest/v1/user/password/reset',
        method: 'POST',
        reqBody: { 'email': this.user.email },
        successMsg: `Sucessfully triggered sending a reset password email to ${this.user.email}.`,
        errorMsg: 'Unable to send reset password email.',
    });
}

function deactivateUser() {
    this.sendCallToServerWithConfirmationBox({
        confirmTitle: 'Confirm User Deactivation',
        confirmMsg: `Are you sure you want to deactivate the account from <strong>${this.user.email}</strong>?`,
        uri: `/rest/v1/user/${this.user.user_id}/deactivate`,
        method: 'POST',
        successMsg: `Sucessfully deactivated account from ${this.user.email}.`,
        errorMsg: 'Unable to deactivate account.',
    });
}

function logoutUser() {
    this.sendCallToServerWithConfirmationBox({
        confirmTitle: 'Confirm User Logout',
        confirmMsg: `Are you sure you want to logout <strong>${this.user.email}</strong> from <strong>all devices</strong>?`,
        uri: `/rest/v1/user/${this.user.user_id}/logout`,
        method: 'GET',
        successMsg: `Sucessfully logged out user ${this.user.email}.`,
        errorMsg: 'Unable to logout user.',
    });
}

function switchRole() {
    let role = (this.user.role === 'pro') ? 'basic' : 'pro';

    this.sendCallToServerWithConfirmationBox({
        confirmTitle: 'Confirm Change of ProductPlan',
        confirmMsg: `Are you sure you want to change the product plan to <strong>${role}</strong> for <strong>${this.user.email}</strong>?`,
        uri: `/rest/v1/user/productplan`,
        method: 'POST',
        reqBody: { 'email': this.user.email, 'role': role },
        successMsg: `Sucessfully changed product plan for user ${this.user.email}.`,
        errorMsg: 'Unable to change product plan.',
    });
}
