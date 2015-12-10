package cs.lmu.grapevine.requests;

import android.app.Activity;
import com.android.volley.toolbox.StringRequest;
import java.util.HashMap;
import java.util.Map;
import cs.lmu.grapevine.BuildConfig;
import cs.lmu.grapevine.activities.Login;
import cs.lmu.grapevine.requests.listeners.error.UnfollowFeedErrorListener;
import cs.lmu.grapevine.requests.listeners.success.UnfollowFeedSuccessListener;

/**
 * Created by jeff on 12/7/15.
 */
public class UnfollowFeedRequest extends StringRequest {

    public UnfollowFeedRequest(Activity parentActivity, String network, String feed) {

        super(Method.DELETE,
              BuildConfig.API_HOST
                + "users/"
                + Login.userId
                + "/feeds/"
                + network
                + "/"
                + feed,
              new UnfollowFeedSuccessListener(parentActivity, network,feed),
              new UnfollowFeedErrorListener(parentActivity)
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
