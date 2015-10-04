package cs.lmu.grapevine;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.TextView;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import java.util.HashMap;
import java.util.Map;

public class FeedEvents extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_feed_events);

        String eventRequestURL = MainActivity.apiURL + "/api/v1/events";
        StringRequest userLoginRequest = new StringRequest(Request.Method.GET,
            eventRequestURL, new Response.Listener<String>() {
            @Override
            public void onResponse(String response) {
                TextView eventFeed = (TextView)findViewById(R.id.event_feed);
                eventFeed.setText(response.toString());
            }

        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                TextView eventFeed = (TextView)findViewById(R.id.event_feed);
                eventFeed.setText(R.string.event_request_error);

            }
        }){
            @Override
            public Map<String, String> getHeaders(){
                HashMap<String, String> eventRequestHeaders = new HashMap<>();
                eventRequestHeaders.put("x-access-token", MainActivity.authenticationToken);
                eventRequestHeaders.put("x-key", "jeff");
                return eventRequestHeaders;
            }
        };
        MainActivity.httpRequestQueue.add(userLoginRequest);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_feed_events, menu);
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
            Intent launchCalendarView = new Intent(getApplicationContext(), CalendarView.class);
            startActivity(launchCalendarView);
        }

        return super.onOptionsItemSelected(item);
    }
}