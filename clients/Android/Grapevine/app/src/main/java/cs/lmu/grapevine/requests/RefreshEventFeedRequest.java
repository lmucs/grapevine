package cs.lmu.grapevine.requests;

import android.app.Activity;
import com.android.volley.toolbox.JsonArrayRequest;
import java.util.HashMap;
import java.util.Map;
import cs.lmu.grapevine.BuildConfig;
import cs.lmu.grapevine.activities.Login;
import cs.lmu.grapevine.requests.listeners.error.RefreshEventFeedErrorListener;
import cs.lmu.grapevine.requests.listeners.success.RefreshEventFeedSuccessListener;

/**
 * Created by jeff on 12/1/15.
 */
public class RefreshEventFeedRequest extends JsonArrayRequest {
    private static String getLatestUrl = BuildConfig.API_HOST
                                  + "users/"
                                  +Login.userId
                                  + "/events/";

    public RefreshEventFeedRequest(Activity parentActivity) {
        super(getLatestUrl + Login.lastRefresh,
              new RefreshEventFeedSuccessListener(parentActivity),
              new RefreshEventFeedErrorListener(parentActivity)
             );
    }

    @Override
    public Map<String, String> getHeaders(){
        HashMap<String, String> eventRequestHeaders = new HashMap<>();
        eventRequestHeaders.put("x-access-token", Login.authenticationToken);
        eventRequestHeaders.put("Content-Type", "application/json");

        return eventRequestHeaders;
    }
}
