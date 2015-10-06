package cs.lmu.grapevine.requests.listeners;

import android.app.Activity;
import android.widget.TextView;
import com.android.volley.Response;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import org.json.JSONArray;
import java.util.ArrayList;
import java.util.List;
import cs.lmu.grapevine.Entities.Event;
import cs.lmu.grapevine.R;

/**
 * Listener for successful EventFeedRequests.
 */
public class EventSuccessListener implements Response.Listener<JSONArray> {
    private Activity parentActivity;
    Gson gson = new GsonBuilder().setDateFormat("MM/dd/yyyy").create();

    public EventSuccessListener(Activity parentActivity) {
        this.parentActivity = parentActivity;
    }

    @Override
    public void onResponse(JSONArray response) {
        TextView eventFeed = (TextView)parentActivity.findViewById(R.id.event_feed);
        deserializeJson(response);
    }

    private ArrayList<Event> deserializeJson(JSONArray userEventsJSON) {
        ArrayList<Event> usersEvents = gson.fromJson(userEventsJSON.toString(), new TypeToken<List<Event>>() {
        }.getType());

        return usersEvents;
    }
}