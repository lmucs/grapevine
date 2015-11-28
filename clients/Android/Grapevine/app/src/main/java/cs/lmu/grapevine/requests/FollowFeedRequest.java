package cs.lmu.grapevine.requests;

import android.app.Activity;
import android.view.View;
import android.widget.ProgressBar;
import com.android.volley.toolbox.JsonObjectRequest;
import java.util.HashMap;
import java.util.Map;
import cs.lmu.grapevine.BuildConfig;
import cs.lmu.grapevine.R;
import cs.lmu.grapevine.activities.Login;
import cs.lmu.grapevine.requests.listeners.error.FollowFeedErrorListener;
import cs.lmu.grapevine.requests.listeners.success.FollowFeedSuccessListener;

/**
 * Request to allow a user to follow a Facebook or Twitter group's events.
 */
public class FollowFeedRequest extends JsonObjectRequest {
    private Activity parentActivity;
    private static String followFeedUrl = BuildConfig.API_HOST
                                          + "users/"
                                          + Login.userId
                                          + "/feeds";

    public FollowFeedRequest(Activity parentActivity, String bodyString) {
        super(Method.POST,
              followFeedUrl,
              RequestHelper.serializeRequestBody(bodyString),
              new FollowFeedSuccessListener(parentActivity),
              new FollowFeedErrorListener(parentActivity)
        );
        this.parentActivity = parentActivity;
        showRequestSpinner();
    }

    private void showRequestSpinner() {
        ProgressBar loginProgress = (ProgressBar)parentActivity.findViewById(R.id.follow_feed_progress);
        loginProgress.setVisibility(View.VISIBLE);
    }

    @Override
    public Map<String, String> getHeaders(){
        HashMap<String, String> eventRequestHeaders = new HashMap<>();
        eventRequestHeaders.put("x-access-token", Login.authenticationToken);
        eventRequestHeaders.put("Content-Type", "application/json");

        return eventRequestHeaders;
    }
}
