package cs.lmu.grapevine.requests.listeners.error;

import android.app.Activity;
import android.view.View;
import android.widget.TextView;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import cs.lmu.grapevine.R;

/**
 * Created by jeff on 11/21/15.
 */
public class FollowFeedErrorListener implements Response.ErrorListener {
    private Activity parentActivity;

    public FollowFeedErrorListener(Activity parentActivity) {
        this.parentActivity = parentActivity;
    }

    @Override
    public void onErrorResponse(VolleyError error) {
        stopProgressSpinner();
        setErrorMessage();

    }

    public void stopProgressSpinner(){
        parentActivity.findViewById(R.id.follow_feed_progress).setVisibility(View.INVISIBLE);
    }

    public void setErrorMessage() {
        TextView followFeedError = (TextView)parentActivity.findViewById(R.id.feed_error_message);
        followFeedError.setText(R.string.follow_feed_error);
    }
}
