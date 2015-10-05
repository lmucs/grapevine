package cs.lmu.grapevine.requests.listeners;

import android.app.Activity;
import android.widget.TextView;
import com.android.volley.Response;
import org.json.JSONObject;
import cs.lmu.grapevine.R;

/**
 * Listener for successful EventFeedRequests.
 */
public class EventSuccessListener implements Response.Listener<JSONObject> {
    private Activity parentActivity;

    public EventSuccessListener(Activity parentActivity) {
        this.parentActivity = parentActivity;
    }

    @Override
    public void onResponse(JSONObject response) {
        TextView eventFeed = (TextView)parentActivity.findViewById(R.id.event_feed);
        eventFeed.setText(response.toString());
    }
}