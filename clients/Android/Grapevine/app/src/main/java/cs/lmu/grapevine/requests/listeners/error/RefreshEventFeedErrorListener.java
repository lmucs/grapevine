package cs.lmu.grapevine.requests.listeners.error;

import android.app.Activity;
import android.support.v4.widget.SwipeRefreshLayout;
import android.widget.Toast;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import cs.lmu.grapevine.R;

/**
 * Created by jeff on 12/1/15.
 */
public class RefreshEventFeedErrorListener implements Response.ErrorListener {
    private Activity parentActivity;

    public RefreshEventFeedErrorListener(Activity parentActivity) {
        this.parentActivity = parentActivity;
    }

    @Override
    public void onErrorResponse(VolleyError error) {
        stopRefreshSpinner();
        toastErrorMessage();
    }

    private void toastErrorMessage() {
        int duration = Toast.LENGTH_SHORT;
        Toast toast = Toast.makeText(parentActivity, parentActivity.getString(R.string.refresh_error_toast), duration);
        toast.show();
    }

    private void stopRefreshSpinner() {
        SwipeRefreshLayout feedContainer = (SwipeRefreshLayout)parentActivity.findViewById(R.id.feed_container);
        feedContainer.setRefreshing(false);
    }
}
