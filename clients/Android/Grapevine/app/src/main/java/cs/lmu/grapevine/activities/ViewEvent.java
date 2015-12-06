package cs.lmu.grapevine.activities;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.Button;
import android.widget.TextView;
import java.sql.Date;
import cs.lmu.grapevine.entities.Event;
import cs.lmu.grapevine.R;

public class ViewEvent extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_view_event);

        Intent intent = getIntent();
        Event eventToView = (Event)intent.getSerializableExtra("event");
        displayEvent(eventToView);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_view_event, menu);
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
        }

        return super.onOptionsItemSelected(item);
    }

    public void displayEvent(Event eventToDisplay) {
        TextView eventTitleView    = (TextView) findViewById(R.id.single_event_title);
        TextView eventDateView     = (TextView) findViewById(R.id.single_event_date);
        TextView eventLocationView = (TextView) findViewById(R.id.single_event_location);
        TextView eventUrlView      = (TextView) findViewById(R.id.single_event_url);
        Button   linkToEvent       = (Button)   findViewById(R.id.link_to_event);
        TextView originalPostView  = (TextView) findViewById(R.id.single_event_original_post);
                
        if(!(eventToDisplay.getTitle() == null)) {
            eventTitleView.setText(eventToDisplay.getTitle());
        } else {
            eventTitleView.setText(R.string.untitled_event_title);
        }

        //TODO - INSERT LOCATION
        

        if (!(eventToDisplay.getPostContent() == null)) {
            originalPostView.setText(eventToDisplay.getPostContent());
        } else {
            originalPostView.setText(R.string.no_post_content_message);
        }

        //any event that doesn't have a date shouldn't make it into the database
        Date eventStartTime = new Date(eventToDisplay.getStartTimeTimestamp());
        eventDateView.setText(eventStartTime.toString());

        if(!(eventToDisplay.getUrl() == null)) {
            eventUrlView.setText(eventToDisplay.getUrl());
        }
    }
}
