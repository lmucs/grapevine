var event = function (uid, title, date, time, owner, orgUrl, timeProcessed) {
    this.uniqueId = uid;
    this.title = title;
    this.date = date; // to do: format
    this.time = time;
    this.owner = owner;
    this.status = "In Progress"; //this.determineStatus(time);
    this.orgUrl = orgUrl;
    this.timeProcessed = timeProcessed;
    this.other; // to do when I see how opt. attrs are returned

    this.determineStatus = function (eventTime) {
        //
    }

    this.getTimeTillEvent = function (eventTime) {
        //
    }

    this.setOptionalAttributes = function () {
        // to do when I see how opt. attrs are returned
    }
}