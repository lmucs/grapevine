package cs.lmu.grapevine.Entities;

import android.location.Location;
import java.sql.Date;
import java.sql.Time;

public class Event {
    private String title;
    private Date date;
    private String status;
    private int id;
    private Time timeProcessed;
    private Location location;
    private Time startTime;
    private Time endTime;
    private boolean repeatsWeekly;
    private String[] tags;
    private String URL;

    public Event(String title) {

        this.title = title;
    }

    public String getTitle() {

        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Time getTimeProcessed() {
        return timeProcessed;
    }

    public void setTimeProcessed(Time timeProcessed) {
        this.timeProcessed = timeProcessed;
    }

    public Location getLocation() {
        return location;
    }

    public void setLocation(Location location) {
        this.location = location;
    }

    public Time getStartTime() {
        return startTime;
    }

    public void setStartTime(Time startTime) {
        this.startTime = startTime;
    }

    public Time getEndTime() {
        return endTime;
    }

    public void setEndTime(Time endTime) {
        this.endTime = endTime;
    }

    public boolean isRepeatsWeekly() {
        return repeatsWeekly;
    }

    public void setRepeatsWeekly(boolean repeatsWeekly) {
        this.repeatsWeekly = repeatsWeekly;
    }

    public String[] getTags() {
        return tags;
    }

    public void setTags(String[] tags) {
        this.tags = tags;
    }

    public String getURL() {
        return URL;
    }

    public void setURL(String URL) {
        this.URL = URL;
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
