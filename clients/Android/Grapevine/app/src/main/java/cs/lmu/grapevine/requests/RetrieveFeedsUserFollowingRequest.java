package cs.lmu.grapevine.requests;

import android.app.Activity;
import com.android.volley.toolbox.JsonArrayRequest;
import java.util.HashMap;
import java.util.Map;
import cs.lmu.grapevine.BuildConfig;
import cs.lmu.grapevine.activities.Login;
import cs.lmu.grapevine.requests.listeners.error.RetrieveUserFeedsErrorListener;
import cs.lmu.grapevine.requests.listeners.success.RetrieveUserFeedsSuccessListener;

/**
 * Created by jeff on 12/4/15.
 */
public class RetrieveFeedsUserFollowingRequest extends JsonArrayRequest {
    private Activity parentActivity;
    private static String feedsURL = BuildConfig.API_HOST
                              + "users/"
                              + Login.userId
                              + "/feeds";

    public RetrieveFeedsUserFollowingRequest(Activity parentActivity) {
        super(Method.GET,
              feedsURL,
              null,
              new RetrieveUserFeedsSuccessListener(parentActivity),
              new RetrieveUserFeedsErrorListener(parentActivity)
              );
        this.parentActivity = parentActivity;
    }

    @Override
    public Map<String, String> getHeaders(){
        HashMap<String, String> eventRequestHeaders = new HashMap<>();
        eventRequestHeaders.put("x-access-token", Login.authenticationToken);
        eventRequestHeaders.put("Content-Type", "application/json");

        return eventRequestHeaders;
    }
}
