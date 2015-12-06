package cs.lmu.grapevine.activities;

import android.content.Intent;
import android.support.v4.view.MenuItemCompat;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.ProgressBar;
import java.util.ArrayList;
import cs.lmu.grapevine.R;
import cs.lmu.grapevine.entities.Event;
import cs.lmu.grapevine.listeners.EventListClickListener;
import cs.lmu.grapevine.requests.EventFeedRequest;
import cs.lmu.grapevine.requests.RefreshEventFeedRequest;

public class EventFeed extends AppCompatActivity {
    public static ArrayList<Event> usersEvents;
    public static ArrayAdapter usersEventsAdapter;
    private static MenuItem miActionProgressItem;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.event_feed);
        ListView eventFeed = (ListView)findViewById(R.id.event_feed);
        eventFeed.setOnItemClickListener(new EventListClickListener(this));

        EventFeedRequest getUserEvents = new EventFeedRequest(this);
        Login.httpRequestQueue.add(getUserEvents);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_event_feed, menu);

        miActionProgressItem = menu.findItem(R.id.miActionProgress);
        // Extract the action-view from the menu item
        ProgressBar v =  (ProgressBar) MenuItemCompat.getActionView(miActionProgressItem);
        showRequestProgressSpinner();
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        } else if (id == R.id.action_launch_calendar) {
            viewCalendar();
        } else if (id == R.id.action_add_group) {
            launchAddGroup();
        } else if (id == R.id.action_refresh_feed) {
            refreshFeed();
        }

        return super.onOptionsItemSelected(item);
    }

    public void viewCalendar() {
        Intent launchCalendarView = new Intent(getApplicationContext(), CalendarView.class);
        startActivity(launchCalendarView);
    }

    public void launchAddGroup() {
        Intent addGroup = new Intent(this, ManageFeeds.class);
        startActivity(addGroup);
    }

    public void refreshFeed() {
        showRequestProgressSpinner();
        RefreshEventFeedRequest getNewEvents = new RefreshEventFeedRequest(this);
        Login.httpRequestQueue.add(getNewEvents);
    }

    private void showRequestProgressSpinner() {
        miActionProgressItem.setVisible(true);
    }

    public static void hideRequestProgressSpinner() {
        miActionProgressItem.setVisible(false);
    }
}