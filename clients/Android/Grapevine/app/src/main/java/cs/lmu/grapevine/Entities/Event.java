package cs.lmu.grapevine.Entities;

import com.google.gson.annotations.SerializedName;
import java.sql.Date;

public class Event {
    private String title;
    private Date date;
    private boolean allDay;
    private String status;
    private int id;
    private int timestamp;
    private String location;
    @SerializedName("startTime")
    private int startTimeTimestamp;
    @SerializedName("endTime")
    private int endTimeTimestamp;
    private boolean repeatsWeekly;
    private String[] tags;
    private String URL;
    private String origin;
    private String post;

    private Event(String title) {
        this.title = title;
    }

    private String getTitle() {
        return title;
    }

    private void setTitle(String title) {
        this.title = title;
    }

    private Date getDate() {
        return date;
    }

    private void setDate(Date date) {
        this.date = date;
    }

    private String getStatus() {
        return status;
    }

    private void setStatus(String status) {
        this.status = status;
    }

    private int getId() {
        return id;
    }

    private void setId(int id) {
        this.id = id;
    }

    private int getTimeProcessed() {
        return timestamp;
    }

    private void setTimeProcessed(int timeProcessed) {
        this.timestamp = timeProcessed;
    }

    private String getLocation() {
        return location;
    }

    private void setLocation(String location) {
        this.location = location;
    }

    private int getStartTimeTimestamp() {
        return startTimeTimestamp;
    }

    private void setStartTimeTimestamp(int startTimeTimestamp) {
        this.startTimeTimestamp = startTimeTimestamp;
    }

    private int getEndTimeTimestamp() {
        return endTimeTimestamp;
    }

    private void setEndTimeTimestamp(int endTimeTimestamp) {
        this.endTimeTimestamp = endTimeTimestamp;
    }

    private boolean isRepeatsWeekly() {
        return repeatsWeekly;
    }

    private void setRepeatsWeekly(boolean repeatsWeekly) {
        this.repeatsWeekly = repeatsWeekly;
    }

    private String[] getTags() {
        return tags;
    }

    private void setTags(String[] tags) {
        this.tags = tags;
    }

    private String getURL() {
        return URL;
    }

    private void setURL(String URL) {
        this.URL = URL;
    }

    public String getPost() {
        return post;
    }

    public void setPost(String post) {
        this.post = post;
    }

    public String getOrigin() {
        return origin;
    }

    public void setOrigin(String origin) {
        this.origin = origin;
    }

    public boolean isAllDay() {
        return allDay;
    }

    public void setAllDay(boolean allDay) {
        this.allDay = allDay;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Event event = (Event) o;

        return id == event.id;
    }

    @Override
    public int hashCode() {
        return id;
    }
}
