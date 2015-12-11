package cs.lmu.grapevine.requests.listeners.error;

import android.app.Activity;
import android.widget.TextView;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import cs.lmu.grapevine.R;

/**
 * Created by jeff on 12/7/15.
 */
public class UnfollowFeedErrorListener implements Response.ErrorListener {
    private Activity parentActivity;

    public UnfollowFeedErrorListener(Activity parentActivity) {
        this.parentActivity = parentActivity;
    }

    @Override
    public void onErrorResponse(VolleyError error) {
       TextView errorContainer = (TextView)parentActivity.findViewById(R.id.feed_error_message);
       errorContainer.setText(R.string.unfollow_error);
    }
}
