package cs.lmu.grapevine.activities;

import android.content.Intent;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import com.roomorama.caldroid.CaldroidFragment;
import java.util.Calendar;
import java.util.Date;
import cs.lmu.grapevine.R;
import cs.lmu.grapevine.adapters.EventFeedArrayAdapter;
import cs.lmu.grapevine.listeners.CalendarListener;
import cs.lmu.grapevine.listeners.EventListClickListener;

public class CalendarView extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_calendar_view);

        CaldroidFragment caldroidFragment = new CaldroidFragment();
        Bundle args = new Bundle();
        Calendar cal = Calendar.getInstance();
        args.putInt(CaldroidFragment.MONTH, cal.get(Calendar.MONTH) + 1);
        args.putInt(CaldroidFragment.YEAR, cal.get(Calendar.YEAR));
        caldroidFragment.setArguments(args);

        FragmentTransaction t = getSupportFragmentManager().beginTransaction();
        t.add(R.id.calendar_fragment_container, caldroidFragment);
        t.commit();
        CalendarListener calendarListener = new CalendarListener(this);
        caldroidFragment.setCaldroidListener(calendarListener);

        populateCalenderWithEvents(caldroidFragment);
        insertCalendarFeed();

    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_calendar_view, menu);
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
        } else if (id == R.id.action_add_group) {
            launchAddGroup();
        }

        return super.onOptionsItemSelected(item);
    }

    private void launchAddGroup() {
        Intent addGroup = new Intent(this, ManageFeeds.class);
        startActivity(addGroup);
    }

    private void populateCalenderWithEvents(CaldroidFragment calendar) {
        for (int i = 0; i < EventFeed.usersEvents.size(); i++) {
            Date eventDate = new Date(EventFeed.usersEvents.get(i).getStartTimeTimestamp());
            calendar.setBackgroundResourceForDate(R.color.event_highlight, eventDate);
        }

        calendar.refreshView();
    }

    private void insertCalendarFeed() {
        if (EventFeed.usersEvents.size() == 0){
            printEmptyFeedMessage();
        }
        else {
            removeEmptyMessageContainer();
            insertEventsIntoFeed();
        }

    }

    private void printEmptyFeedMessage() {
        TextView emptyMessageContainer = (TextView) findViewById(R.id.empty_message);
        emptyMessageContainer.setText(R.string.event_list_empty);

    }

    private void insertEventsIntoFeed() {
        ListView eventFeed = (ListView) findViewById(R.id.calendar_feed);
        EventFeedArrayAdapter adapter = new EventFeedArrayAdapter(this,EventFeed.usersEvents);
        eventFeed.setAdapter(adapter);
        eventFeed.setOnItemClickListener(new EventListClickListener(this));
    }

    private void removeEmptyMessageContainer() {
        TextView emptyMessageContainer = (TextView)findViewById(R.id.empty_message);
        ((LinearLayout)emptyMessageContainer.getParent()).removeView(emptyMessageContainer);
    }

}
