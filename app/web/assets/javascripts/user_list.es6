//= require messages.js

function search(event) {
    event.preventDefault();
    let searchValue = this.$refs.search.value;
    let searchTerms = searchValue.trim().split(',');

    if(!searchTerms || !searchTerms[0]){
       this.$refs.search.value = '';
       return; 
    }

    if( searchTerms.length > 1 ) {
        let requestOptions = {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ 'searchTerm': searchValue })
        };

        fetch('/rest/v1/user/search', requestOptions)
            .then(response => {
                if (response.ok) {
                    return response.json();
                } else if (response.status === 401) {
                    this.$refs.form.submit();
                } else {
                    this.showErrorMessage(`Unable to display search results - the server has returned: ${response.status}`);
                }
            })
            .then(json => {
                this.userList = json;
            })
            .catch(error => {
                this.showErrorMessage('Unable to search for user - see the console for more information');
                console.error('There was an error!', error);
            });
    } else if(searchTerms.length == 1) {
        this.$refs.form.submit();
    } else {
        this.$refs.search.value = '';
    }
}